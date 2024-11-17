# ZeusGaza Scanner

**ZeusGaza Scanner** is a powerful and comprehensive tool for security professionals and bug bounty hunters. It automates the process of discovering subdomains, gathering URLs, and analyzing websites for various attack vectors. This script leverages multiple tools to provide detailed insights into the target domain.

## Features

- **Subdomain Discovery**: Uses `Subfinder` and `Sublist3r` to discover subdomains.
- **Wayback Machine Analysis**: Utilizes `Waybackurls` to find historical URLs.
- **Website Crawling**: Employs `Katana` to crawl through discovered subdomains.
- **Technology Identification**: Uses `WhatWeb` to identify technologies and services used by the website.
- **Status Code Analysis**: Validates URLs and checks their status codes using `httpx`.

## Prerequisites

Ensure you have the following tools installed:

- [Subfinder](https://github.com/projectdiscovery/subfinder)
- [Sublist3r](https://github.com/aboul3la/Sublist3r)
- [Waybackurls](https://github.com/tomnomnom/waybackurls)
- [Katana](https://github.com/katana-framework/katana)
- [WhatWeb](https://github.com/urbanadventurer/WhatWeb)
- [Hakrawler](https://github.com/hakluke/hakrawler)
- [httpx](https://github.com/projectdiscovery/httpx)

## Installation

Clone the repository:
git clone https://github.com/zeusvlun/zeusgaza.git
cd zeusgaza
Make the script executable:
chmod +x zeusgaza.sh
Usage
Run the script with your target domain:
./zeusgaza.sh -u example.com
Options
-u <URL>: Specify the target domain to scan.
-h: Display help information.
What Does the Script Do?
WhatWeb: Identifies the technologies and services running on the target website.
Subfinder and Sublist3r: Discovers subdomains related to the target domain.
Waybackurls: Retrieves historical snapshots of the website from the Wayback Machine.
Katana: Crawls through the discovered subdomains to gather additional URLs.
Hakrawler: Searches for additional URLs and resources using various methods.
httpx: Validates URLs and checks their status codes (e.g., 200, 403) to determine their accessibility.
Results
The script saves the results of each tool in separate files:

WhatWeb Results: saved as whatweb_results_<domain>.txt
Subfinder Results: saved as subfinder_results_<domain>.txt
Sublist3r Results: saved as sublist3r_results_<domain>.txt
Waybackurls Results: saved as waybackurls_results_<domain>.txt
Katana Results: saved as katana_results_<domain>.txt
Hakrawler Results: saved as hakrawler_results_<domain>.txt
License
This project is licensed under the MIT License. See the LICENSE file for more information.

## Acknowledgments
Thanks to the authors of the tools used: Subfinder, Sublist3r, Waybackurls, Katana, WhatWeb
Special thanks to the bug bounty community for their continuous support and contributions.
## Contributing
Feel free to fork the repository and submit pull requests with improvements or bug fixes. For major changes, please open an issue first to discuss what you would like to change.

## Contact
If you have any questions or suggestions, feel free to reach out to zeusvlun@gmail.com or open an issue on the GitHub repository.