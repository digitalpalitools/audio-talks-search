[![License: CC BY-NC-SA 4.0](https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-sa/4.0/)

# Ṭhānissaro Bhikkhu Talks Search Application

Search through Ṭhānissaro Bhikkhu's talks.

Front-end:

- Sources: https://github.com/digitalpalitools/web-ui
- Deployed at: https://d.pali.tools/apps#/talks-search/talks/mindfulness

# Backlog

- [x] dhammatalks [before 20211003]
  - [ ] structured data file: dateId, ytid, author, channel -> re-index
  - [ ] complete remaining 1k files
- [ ] Core
  - [x] AzSearch infra
  - [ ] Front end
    - [x] Search results
    - [ ] Play
    - [ ] View subtitle
  - [ ] Add CI
- [ ] Suttas
- [ ] Core v1
  - [ ] Play from specific time
  - [ ] Index transcribed audio
- [ ] Short dhammatalks
- [ ] Lectures & longer talks

# Instructions

## Download subtitles

```youtube-dl --dateafter 20210101 --datebefore 20210101 --skip-download --write-auto-sub --sub-format srv1 https://www.youtube.com/c/DhammatalksOrg/videos```

## Convert to text

```dir -rec -filt *.srv1 .\dt\ | % { ..\format.ps1 $_.FullName }```

## Upload to blob store

```azcopy copy ".\talks\dt\*.json" "https://tsbtalks.blob.core.windows.net/tsbtalks/dt?sv=2019-12-12&st=2021-10-02T22%3A34%3A41Z&se=2021-10-03T22%3A34%3A41Z&sr=c&sp=racwdxlt&sig=E0dCSUbfWWEH%2B8j2YhN5rHZCjXrB7dii6aKMZpqnlqE%3D" --recursive```

## Test search

```ps1
$apiKey = 'D0CA5AF719558AA344C3111934DA874D';
$headers = @{ "api-key" = $apiKey; "Accept" = "application/json; odata.metadata=none" }
$res = Invoke-RestMethod -Method Get -Uri 'https://tsbtalks.search.windows.net/indexes/azureblob-index/docs?api-version=2020-06-30&search=craving as companion&searchMode=all&searchFields=content&highlight=content&highlightPreTag=<XXX>&highlightPostTag=</XXX>' -Headers $headers
$res.value[0].'@search.highlights'.content
```

# References

- [Short youtube-dl tutorial](https://ostechnix.com/youtube-dl-tutorial-with-examples-for-beginners/)
