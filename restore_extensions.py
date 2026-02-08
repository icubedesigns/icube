import os
import re

# Directory containing the HTML files
html_dir = r"c:/Users/USER/Downloads/Icube website/arinde-architecture-interior-html-template-2025-10-01-07-10-18-utc/arinde/html"

def restore_extensions():
    # Regex to find hrefs that are just filenames (letters, numbers, hyphens, underscores)
    # Excludes:
    # - URLs with schemes (http:, mailto:, tel:) -> containing ':'
    # - Files with extensions -> containing '.'
    # - Paths with directories -> containing '/'
    # - Anchors -> starting with '#' (handled by not matching if it's just '#')
    #
    # We look for href="captured_group"
    # captured_group should not start with #
    # captured_group should not contain . : /
    
    # Pattern: href="([^"#.:/]+)"
    # We want to replace it with href="\1.html"
    
    # Constructing regex to be safe:
    # ensure it's exactly href="something"
    # [^"#.:/\s] ensures we don't match things with spaces if that's an issue, but standard URLs shouldn't have them
    
    pattern = re.compile(r'href="([^"#.:/]+)"')
    
    count_files_changed = 0
    count_links_changed = 0
    
    for filename in os.listdir(html_dir):
        if filename.lower().endswith(".html"):
            filepath = os.path.join(html_dir, filename)
            
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
            
            new_content = content
            
            # Function to replace and count
            def replace_callback(match):
                nonlocal count_links_changed
                link = match.group(1)
                # Double check to verify we aren't replacing something we shouldn't
                # e.g. "javascript:void(0)" - wait, ':' is excluded.
                # e.g. "style.css" - '.' is excluded.
                # e.g. "folder/file" - '/' is excluded.
                # e.g. "#section" - '#' is excluded (if it was just # it wouldn't match + quantifier properly if empty, or we can check)
                
                print(f"  Replacing: {link} -> {link}.html")
                count_links_changed += 1
                return f'href="{link}.html"'
            
            # Apply substitution
            # We use sub with a callback to count changes and print them
            if pattern.search(content):
                print(f"Processing {filename}...")
                new_content = pattern.sub(replace_callback, content)
            
            if new_content != content:
                with open(filepath, 'w', encoding='utf-8') as f:
                    f.write(new_content)
                count_files_changed += 1
                
    print(f"\nSummary: Modified {count_links_changed} links in {count_files_changed} files.")

if __name__ == "__main__":
    restore_extensions()
