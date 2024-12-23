from jinja2 import Environment, PackageLoader, select_autoescape

env: Environment = Environment(
    loader=PackageLoader("wholesomecoolness"),
    autoescape=select_autoescape()
)
