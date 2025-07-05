#!/usr/bin/env python3

import requests
from bs4 import BeautifulSoup
import yfinance as yf
from datetime import datetime, timedelta, UTC
import pandas as pd
import re

# Constants
FINVIZ_NEWS_URL = "https://finviz.com/news.ashx?v=3"
HEADERS = {"User-Agent": "Mozilla/5.0"}
TIME_WINDOW_MINUTES = 30  # Look back 30 minutes

def get_recent_news():
    """Scrape Finviz news and extract tickers from headlines within the last 30 minutes."""
    response = requests.get(FINVIZ_NEWS_URL, headers=HEADERS)
    soup = BeautifulSoup(response.text, "html.parser")
    news_items = soup.select("table.fullview-news-outer tr")

    tickers = set()
    now = datetime.now(UTC)

    for row in news_items:
        time_tag = row.select_one("td:nth-of-type(1)")
        link_tag = row.select_one("a")

        if not time_tag or not link_tag:
            continue

        timestamp = time_tag.text.strip()

        if ':' in timestamp:  # e.g. "12:40PM"
            try:
                news_time_naive = datetime.strptime(timestamp, "%I:%M%p")
                news_time = now.replace(
                    hour=news_time_naive.hour,
                    minute=news_time_naive.minute,
                    second=0,
                    microsecond=0
                )
                # Adjust if future time due to day rollover
                if news_time > now:
                    news_time -= timedelta(days=1)

                if now - news_time > timedelta(minutes=TIME_WINDOW_MINUTES):
                    continue
            except Exception as e:
                print(f"[!] Time parsing error: {e}")
                continue
        else:
            continue  # Skip entries like "Jul-02-25"

        headline = link_tag.text.strip()
        found_tickers = re.findall(r'\b[A-Z]{2,5}\b', headline)

        for ticker in found_tickers:
            tickers.add(ticker)

    return list(tickers)

def get_stock_info(tickers):
    """Retrieve stock price and float using yfinance."""
    matched = []

    for ticker in tickers:
        try:
            stock = yf.Ticker(ticker)
            info = stock.info

            price = info.get('regularMarketPrice')
            float_shares = info.get('floatShares')

            if price is None or float_shares is None:
                continue

            float_millions = float_shares / 1_000_000

            if price >= 5 and float_millions < 11:
                matched.append({
                    "Ticker": ticker,
                    "Company": info.get("shortName", ""),
                    "Price": price,
                    "Float (M)": round(float_millions, 2)
                })
        except Exception as e:
            print(f"[!] Failed for {ticker}: {e}")
            continue

    return pd.DataFrame(matched)

def run_monitor():
    print(f"\n🕒 Scan at {datetime.now(UTC).strftime('%Y-%m-%d %H:%M:%S UTC')}")
    tickers = get_recent_news()
    print(f"📰 Tickers extracted from headlines: {tickers}")

    if tickers:
        df = get_stock_info(tickers)
        if not df.empty:
            print("\n✅ Matched Stocks:\n")
            print(df.to_string(index=False))
        else:
            print("❌ No matches found with required price and float.")
    else:
        print("❌ No tickers found in the last 30 minutes of news.")

if __name__ == "__main__":
    run_monitor()

