# Here we have trello butler jsons

Trello has the problem. If we want to format json in there Butler engine, it won't work. That's we need to push one line jsons there.
Write json in one line looks like hell. We've simplified this process.

You can find all actions structures in docs/trello/butler/actions

Also we have the script. This script converts yaml to one-line json.

Just run `rails r docs/trello/butler/actions/get_one_line_json.rb FILE_WITH_STRUCTURE_PATH`
