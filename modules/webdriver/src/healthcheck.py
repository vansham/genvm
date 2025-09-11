#!/usr/bin/env python3

import asyncio
import os
import aiohttp


async def main():
	async with aiohttp.ClientSession() as session:
		port = int(os.getenv('PORT', '4444'))
		async with session.get(
			f'http://localhost:{port}/render?mode=text&url=https%3A%2F%2Ftest-server.genlayer.com%2Fstatic%2Fgenvm%2Fhello.html'
		) as response:
			print(response.status)
			body = await response.text()
			body = body.strip().lower()
			print(body)
			if body != 'hello world!':
				raise ValueError('unexpected body: ' + body)


asyncio.run(main())
