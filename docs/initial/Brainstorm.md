# Fortuna

## Overview

It's an app to track one's financial life. It contains all your expenses, earnings and can present the data as spreadsheets and graphs. You can also make future projections. It keeps track of bank accounts, investments and credit cards.  

This must be front-end for this app. The back-end can be found at [this repository](https://github.com/artur-rios/fortuna-api).

## Features

- Bank account, investments and credit card tracking
- Manual input of info
- Automatic input of info using [Pluggy API](https://docs.pluggy.ai/docs/quick-pluggy-introduction)
- Import from excel
- Import from some specific PDF layouts
- Export to csv, excel and PDF
- Show data as spreadsheet
- Show data as graphs in different formats, and allowing clicks on the graphic elements to "zoom" into data
- Search, filter, organize, update and delete data
- Use it from a windows app, linux app, browser or mobile with same experience

## Technical constraints

- It must be fast
- Since we are dealing with money, it must precise and reliable
- It must be safe
- The interface must be intuitive and responsive
- One interface, four platforms (Android, Web, Windows, Linux)

## Technologies

- Use Flutter on front-end, with the same front shared between the target devices
- Implement all features from [Fortuna API](https://github.com/artur-rios/fortuna-api)
