import asyncio
import aiohttp
from urllib.parse import urlparse, parse_qs
from tqdm.asyncio import tqdm_asyncio

print("Fetching problem url....")

async def main():
    try:
        async with aiohttp.ClientSession() as session:
            async with session.get("http://localhost:27121/") as resp:
                problem = await resp.json()
        url = urlparse(problem['url'])
        print(f"Got Problem url ✅: {problem['url']}")
    except:
        print("Cannot fetch problem url from cp-assist 🚫")
        return

    queries = parse_qs(url.query)
    if 'id' not in queries:
        print("ID not found 😵")
        return

    id = queries['id'][0]

    print("Fetching problem details....")
    try:
        async with aiohttp.ClientSession() as session:
            async with session.get(f"https://judgedat.u-aizu.ac.jp/testcases/{id}/header") as resp:
                headers = (await resp.json())['headers']
    except:
        print("Cannot fetch problem details 😩")
        return

    print(f"Got {len(headers)} test cases 🧶")

    async def fetch_case(session, serial):
        url = f"https://judgedat.u-aizu.ac.jp/testcases/{id}/{serial}"
        async with session.get(url) as resp:
            test_case = await resp.json()
            return {'input': test_case['in'], 'output': test_case['out']}

    async with aiohttp.ClientSession() as session:
        tasks = [fetch_case(session, h['serial']) for h in headers]
        test_cases = await tqdm_asyncio.gather(*tasks, desc="Fetching test cases: ")

    async with aiohttp.ClientSession() as session:
        post_result = await session.post("http://localhost:27121/test_cases", json=test_cases)
        if post_result.status == 200:
            print("Successfully added test cases ✅")
        else:
            print(f"Failed to add test cases with status code: {post_result.status}")

# Run the async main
asyncio.run(main())
