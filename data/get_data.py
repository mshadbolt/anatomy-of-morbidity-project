from bs4 import BeautifulSoup
import requests
import zipfile
import io
import os

with open('statcan.html') as infile:
    html_doc = infile.read()

soup = BeautifulSoup(html_doc, 'html.parser')

for tag in soup.find_all(attrs={'class': 'arrayid'}):
    tag = tag.string[1:-1]
    tag = ''.join(tag.split('-')[:-1])

    if os.path.exists(tag + '.csv') and os.path.exists(tag + '_MetaData.csv'):
        print('skipping dataset {}, already exists'.format(tag))
        continue

    download_url = 'https://www150.statcan.gc.ca/n1/tbl/csv/{}-eng.zip'.format(tag)

    print('downloading from {}'.format(download_url))
    r = requests.get(download_url)
    if r.status_code != 200:
        raise Exception('download could not be completed, status code {}'.format(r.status_code))

    z = zipfile.ZipFile(io.BytesIO(r.content))
    z.extractall()

print('download completed!')
