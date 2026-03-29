# Crawl

Crawl multiple pages from a website.

## Basic Usage

```bash
# Start crawl (returns job ID)
firecrawl crawl https://example.com

# Wait for completion
firecrawl crawl https://example.com --wait

# With progress
firecrawl crawl https://example.com --wait --progress

# Check status
firecrawl crawl <job-id>
```

## Common Options

| Option | Description |
|--------|-------------|
| `--wait` | Wait for crawl to complete |
| `--progress` | Show progress |
| `--limit <n>` | Maximum pages to crawl |
| `--max-depth <n>` | Maximum crawl depth |
| `--include-paths <paths>` | Only crawl matching paths |
| `--exclude-paths <paths>` | Skip matching paths |
| `--allow-subdomains` | Include subdomains |
| `--allow-external-links` | Follow external links |
| `--crawl-entire-domain` | Crawl whole domain |
| `--sitemap <mode>` | skip or include sitemap |
| `--ignore-query-parameters` | Dedupe URLs by stripping query params |
| `--delay <ms>` | Delay between requests |
| `--max-concurrency <n>` | Max concurrent requests |
| `--poll-interval <s>` | Poll interval when waiting |
| `--timeout <s>` | Wait timeout |
| `-o, --output <path>` | Save to file |

## Examples

```bash
# Crawl blog section only
firecrawl crawl https://example.com --include-paths /blog,/posts

# Exclude admin pages
firecrawl crawl https://example.com --exclude-paths /admin,/login

# Rate limiting
firecrawl crawl https://example.com --delay 1000 --max-concurrency 2

# Deep crawl
firecrawl crawl https://example.com --limit 1000 --max-depth 10 --wait --progress

# Save results
firecrawl crawl https://example.com --wait -o crawl.json --pretty
```
