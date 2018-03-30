import multiprocessing
import requests
from bs4 import BeautifulSoup


import sql


def generate_token_links():
    result = requests.get("https://coinmarketcap.com/all/views/all/")
    c = result.content
    soup = BeautifulSoup(c)
    coins = soup.find_all("tr")
    for index, coin in enumerate(coins):
        if index==0:continue # header
        links = coin.find_all("a")
        yield "https://coinmarketcap.com"+links[0].attrs["href"]

def scrape_coin_info(link):
    result = requests.get(link)
    c = result.content
    soup = BeautifulSoup(c)
    ret = {}

    #image
    image = soup.find("img", {'class':'currency-logo-32x32'}).attrs.get("src")
    ret['image'] = image

    #title and ticker
    title_and_ticker = soup.find("h1", {'class':'text-large'}).get_text().replace("\n","").replace(" ","")
    title = title_and_ticker.split(")")[1].split("(")[0]
    ret['title'] = title
    ticker = title_and_ticker.split("(")[1].split(")")[0]
    ret['ticker'] = ticker

    #links like website & explorer
    bs_links = soup.find("ul",{"class":"list-unstyled"}).find_all("a")
    for bs_link in bs_links:
        ret[ bs_link.get_text().replace(" ",'')] = bs_link.attrs['href']
    return ret


def main():
    links = list(generate_token_links())
    writer = sql.Tokens('adfunnel.tokens')

    #p = multiprocessing.Pool()
    #for data in p.imap_unordered(scrape_coin_info, links):
        #writer.write_later(data)

    for link in links:
        data = scrape_coin_info(link)
        print data
        writer.write_later(data)
        writer.write_all()

if __name__ == "__main__":
    main()

