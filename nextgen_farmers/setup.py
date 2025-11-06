from setuptools import setup, find_packages

with open("requirements.txt") as f:
    install_requires = f.read().strip().split("\n")

# get version from __version__ variable in nextgen_farmers/__init__.py
from nextgen_farmers import __version__ as version

setup(
    name="nextgen_farmers",
    version=version,
    description="ERPNext customization for NextGen Farmers Hub - Agricultural Cooperative Management",
    author="NextGen Farmers Hub",
    author_email="support@nextgenfarmershub.com",
    packages=find_packages(),
    zip_safe=False,
    include_package_data=True,
    install_requires=install_requires
)
