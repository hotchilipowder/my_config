"""Isolated install/startup checks. Optional --plugins points to an existing lazy directory."""
import argparse
import os
from pathlib import Path
import shutil
import subprocess
import tempfile

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--plugins', type=Path)
args = parser.parse_args()
source = Path(__file__).resolve().parents[1]

with tempfile.TemporaryDirectory(prefix='nvim profiles ') as directory:
    root = Path(directory)
    env = dict(os.environ)
    for key, name in [('XDG_CONFIG_HOME', 'config'), ('XDG_DATA_HOME', 'data'),
                      ('XDG_STATE_HOME', 'state'), ('XDG_CACHE_HOME', 'cache')]:
        env[key] = str(root / name)
    env.pop('NVIM_APPNAME', None)
    env['NVIM_ENABLE_LSP'] = '0'
    env['NVIM_ENABLE_ULTISNIPS'] = '0'
    legacy = root / 'config/nvim/init.lua'
    legacy.parent.mkdir(parents=True)
    legacy.write_text('-- existing config\n')
    command = ['bash', str(source / 'install.sh'), 'all' if args.plugins else 'light',
               '--config-home', str(root / 'config'), '--bin-dir', str(root / 'bin')]
    for _ in range(2):
        subprocess.run(command, env=env, check=True, capture_output=True, text=True)
    assert legacy.read_text() == '-- existing config\n'
    assert list((root / 'config').glob('nvim-lite.backup.*/config/init.lua'))
    assert list((root / 'bin').glob('nvim-lite.backup.*/launcher'))
    # Arguments containing spaces must survive the generated launcher.
    sample = root / 'edit me.txt'
    sample.write_text('before\n')

    def check(app, body, overrides=None):
        script = root / 'check.lua'
        script.write_text('''local ok, err = pcall(function()
assert(vim.v.errmsg == "", vim.v.errmsg)
''' + body + '''
end)
if not ok then print(err); vim.cmd('cquit 1') end
vim.cmd('qa!')
''')
        result = subprocess.run(
            [str(root / 'bin' / app), '--headless', '-i', 'NONE', str(sample),
             '+lua dofile(' + repr(str(script)) + ')'],
            env={**env, **(overrides or {})}, text=True, capture_output=True, timeout=45)
        assert result.returncode == 0, result.stdout + result.stderr
        assert 'Error' not in result.stderr, result.stderr

    check('nvim-lite', '''
assert(package.loaded.lazy == nil)
assert(vim.fn.exists(':Lazy') == 0)
assert(vim.fn.expand('%:t') == 'edit me.txt')
assert(vim.fn.maparg(' q', 'n'):find('bdelete'))
vim.api.nvim_buf_set_lines(0, 0, -1, false, { 'after' })
vim.cmd.write()
vim.cmd.undo()
assert(vim.api.nvim_get_current_line() == 'before')
vim.cmd.Explore()
assert(vim.bo.filetype == 'netrw')
''')
    assert sample.read_text() == 'after\n'
    assert not (root / 'data/nvim-lite/lazy').exists()
    print('PASS light: offline startup, edit/save/undo, file browser, spaced paths, backup isolation')

    if args.plugins:
        shutil.copytree(args.plugins, root / 'data/nvim-daily/lazy')
        for lsp in ('0', '1'):
            check('nvim-daily', '''
local plugins = require('lazy.core.config').plugins
assert(not plugins['none-ls.nvim'])
assert(not plugins['symbols-outline.nvim'])
assert(not plugins['cmp-vsnip'])
assert(not plugins['telescope.nvim']._.loaded)
assert(not plugins['nvim-cmp']._.loaded)
assert(vim.fn.maparg(' q', 'n') ~= vim.fn.maparg(' cq', 'n'))
vim.cmd('setfiletype markdown')
require('telescope.builtin').find_files({ cwd = vim.fn.stdpath('config') })
vim.cmd('close')
vim.api.nvim_exec_autocmds('InsertEnter', {})
assert(plugins['nvim-cmp']._.loaded)
assert(require('cmp').get_config().sources[1].name ~= 'vsnip')
require('conform')
vim.cmd('NvimTreeOpen')
vim.cmd('NvimTreeClose')
assert(vim.fn.exists(':TSInstallDefaults') == 2)
if vim.env.NVIM_ENABLE_LSP == '1' then
  assert(vim.lsp.is_enabled('pyright'))
  assert(vim.lsp.config.pyright.cmd[1] == 'pyright-langserver')
  assert(vim.fn.maparg(' ws', 'n'):find('split'))
end
''', {'NVIM_ENABLE_LSP': lsp})
        print('PASS daily: cached plugins, lazy loading, completion, search, file tree, formatting, LSP on/off')
