from aiohttp import web

async def handler(request):
    return web.Response(text="Hello, world!")

app = web.Application()
app.add_routes([web.get('/', handler)])

if __name__ == '__main__':
    web.run_app(app)