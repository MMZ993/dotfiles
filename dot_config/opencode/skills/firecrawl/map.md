# Map

Discover all URLs on a website without scraping content.

## Basic Usage

```bash
# List all URLs (one per line)
firecrawl map https://example.com

# JSON output
firecrawl map https://example.com --json

# Search for specific URLs
firecrawl map https://example.com --search "blog"

# Limit results
firecrawl map https://example.com --limit 500
```

## Common Options

| Option | Description |
|--------|-------------|
| `--limit <n>` | Maximum URLs to discover |
| `--search <query>` | Filter URLs by search query |
| `--sitemap <mode>` | include, skip, or only |
| `--include-subdomains` | Include subdomains |
| `--ignore-query-parameters` | Dedupe URLs with different params |
| `--wait` | Wait for map completion |
| `--timeout <s>` | Timeout for map job |
| `--json` | JSON output |
| `-o, --output <path>` | Save to file |

## Examples

```bash
# Find all product pages
firecrawl map https://shop.example.com --search "product"

# Sitemap URLs only
firecrawl map https://example.com --sitemap only

# Save URL list
firecrawl map https://example.com -o urls.txt

# Include subdomains
firecrawl map https://example.com --include-subdomains --limit 1000
```
