# Download

Bulk site download - combines map + scrape to save site as local files.

## Basic Usage

```bash
# Interactive wizard
firecrawl download https://docs.example.com

# Non-interactive
firecrawl download https://docs.example.com -y

# With screenshots
firecrawl download https://docs.example.com --screenshot --limit 20 -y

# Multiple formats
firecrawl download https://docs.example.com --format markdown,links --screenshot --limit 20 -y
```

## Common Options

| Option | Description |
|--------|-------------|
| `--limit <n>` | Max pages to download |
| `--search <query>` | Filter pages by search query |
| `--include-paths <paths>` | Only download matching paths |
| `--exclude-paths <paths>` | Skip matching paths |
| `--allow-subdomains` | Include subdomains |
| `-y, --yes` | Skip confirmation prompt |

## Scrape Options (also work with download)

| Option | Description |
|--------|-------------|
| `--format <formats>` | Output formats |
| `--html` | HTML output |
| `--only-main-content` | Main content only |
| `--screenshot` | Screenshot |
| `--full-page-screenshot` | Full page screenshot |
| `--include-tags <tags>` | Only include specific tags |
| `--exclude-tags <tags>` | Exclude specific tags |
| `--max-age <ms>` | Reuse cached scrape up to max age |
| `--country <code>` | Geo-target scraping |
| `--languages <codes>` | Preferred language codes |

## Examples

```bash
# HTML download
firecrawl download https://docs.example.com --html --limit 20 -y

# Main content only
firecrawl download https://docs.example.com --only-main-content --limit 50 -y

# Filter to specific paths
firecrawl download https://docs.example.com --include-paths "/features,/sdks"

# Skip localized pages
firecrawl download https://docs.example.com --exclude-paths "/zh,/ja,/fr,/es,/pt-BR"

# Full download with screenshots
firecrawl download https://example.com \\
  --include-paths "/features,/sdks" \\
  --exclude-paths "/admin" \\
  --screenshot \\
  -y
```

## Output Structure

Each format is saved as its own file per page:

```
.firecrawl/
  docs.example.com/
    features/
      scrape/
        index.md       # markdown
        links.txt      # links
        screenshot.png # screenshot
    sdks/
      python/
        index.md
```
