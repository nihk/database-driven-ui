# database-driven-ui

Code to accompany my Medium article: https://medium.com/@nicholas.rose/driving-your-ui-from-a-persistent-model-6136ce73c9

This is an app that fetches data remotely from the GitHub Jobs API, persists it in a local SQLite database, then queries that
data to be displayed in a ListView. Inspired by AAC NetworkBoundResource in that it publishes data progress events 
as asynchronous work in the background continues.

Uses provider and sqflite.

<div align="center">
   <img src="https://github.com/nihk/database-driven-ui/blob/master/lib/screenshots/screnshot.png">
</div>
