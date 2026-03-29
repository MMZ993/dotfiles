# Search

Search the web and optionally scrape results.

## Basic Usage

```bash
# Basic search
firecrawl search "firecrawl web scraping"

# Limit results
firecrawl search "AI news" --limit 10

# Search specific sources
firecrawl search "tech startups" --sources news
firecrawl search "landscape photography" --sources images

# Time-based search
firecrawl search "AI announcements" --tbs qdr:d  # Past day
firecrawl search "tech news" --tbs qdr:w         # Past week

# Search and scrape results
firecrawl search "firecrawl tutorials" --scrape
```

## Common Options

| Option | Description |
|--------|-------------|
| `--limit <n>` | Max results (default: 5, max: 100) |
| `--sources <sources>` | web, images, news |
| `--categories <categories>` | github, research, pdf |
| `--tbs <value>` | Time filter: qdr:h/d/w/m/y |
| `--location <location>` | Geo-targeting |
| `--country <code>` | ISO country code (default: US) |
| `--scrape` | Enable scraping of search results |
| `--scrape-formats <formats>` | Scrape formats (default: markdown) |
| `--only-main-content` | With `--scrape`, scrape main content only (default: true) |
| `--ignore-invalid-urls` | Skip URLs invalid for Firecrawl endpoints |
| `-o, --output <path>` | Save to file |
| `--json` | JSON output |

## Examples

```bash
# Recent research
firecrawl search "React Server Components" --tbs qdr:m --limit 10

# Find GitHub repos
firecrawl search "web scraping library" --categories github --limit 20

# Search and get full content
firecrawl search "firecrawl docs" --scrape --scrape-formats markdown --json -o results.json

# Location-based
firecrawl search "best coffee shops" --location "Berlin,Germany" --country DE

# News from past week
firecrawl search "AI funding" --sources news --tbs qdr:w --limit 15
```
