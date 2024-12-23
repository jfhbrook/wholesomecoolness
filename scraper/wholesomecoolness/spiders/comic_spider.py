import os
from pathlib import Path

import scrapy
import scrapy.exceptions


class ComicSpider(scrapy.Spider):
    name = "comic"
    start_urls = [
        "https://wholesomecoolness.comicgenesis.com/index.html"
    ]

    def parse(self, response):
        file_path = Path(os.getcwd()) / "/".join(response.url.split("/")[2:])
        is_root = not file_path.suffix or file_path.suffix == ".com"
        if is_root:
            file_path = file_path / "index.html"
        os.makedirs(file_path.parent, exist_ok=True)
        file_path.write_bytes(response.body)

        try:
            # Images
            for img in response.css("img::attr(src)").getall():
                if img.startswith("//"):
                    continue
                if img.startswith("http"):
                    continue
                if img.startswith("/"):
                    img = "https://wholesomecoolness.comicgenesis.com" + img
                elif is_root:
                    img = response.url + '/' + img
                else:
                    img = "/".join(response.url.split('/')[:-1] + [img])
                if "wholesomecoolness" not in img:
                    continue
                yield response.follow(img, callback=self.parse)
            # Links
            for link in response.css("a::attr(href)").getall():
                if link.startswith("//"):
                    continue
                if link.startswith("http"):
                    continue
                if link.startswith("/"):
                    link = "https://wholesomecoolness.comicgenesis.com" + link
                elif is_root:
                    link = response.url + '/' + link
                else:
                    link = "/".join(response.url.split('/')[:-1] + [link])
                if "wholesomecoolness" not in link:
                    continue
                yield response.follow(link, callback=self.parse)
        except scrapy.exceptions.NotSupported:
            pass
