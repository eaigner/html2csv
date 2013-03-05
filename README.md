# Installing

1. Install Xcode from the Mac App Store
2. Install Homebrew

        ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"

3. Install libxml2 and libxslt

        brew install libxml2 libxslt
        brew link libxml2 libxslt --force

4. Install bundler

        sudo gem install bundler

5. Change to the directory parse.rb is in and execute

        bundle install
        chmod +x parse.rb

6. View the help

        ./parse.rb --help

7. Run!

# Usage

    Usage: parse.rb [options]
    
    -d, --data DIR                   Directory containing HTML files
    -o, --output DIR                 Output CSV file name
    -x, --xpaths FILE                File containing XPaths to match
    -e, --encoding ENC               Text encoding to convert to

# XPath file format

Using `parse.rb -x Example.xpaths` XPaths are mapped to columns (one pair per line)

## Example.xpaths

    <Column-1>: <XPath-1>
    <Column-2>: <XPath-2>
    ...