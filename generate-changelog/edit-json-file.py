import json
import ijson
import argparse
import re

parser = argparse.ArgumentParser()
parser.add_argument(
    "--path",
    type=str,
    default="./context.json",
    required=False,
    help="relative path to search for source repos",
)
path = parser.parse_args().path

with open(path, "r") as obj:
  gen = ijson.items(obj, "item.commits.item")
  data = []
  for idx, dict_data in enumerate(gen):
    if not idx % 100:
      print("")
    print(dict_data)
    if dict_data["message"]:
      pattern = r"\(#[0-9]*?\) \(#[0-9]*?\)"
      title = dict_data["message"].replace('"', '')
      if re.search(pattern, dict_data["message"]):
        if dict_data["links"]:
          single_data = {"id": dict_data["id"], "type": dict_data["group"], "scope": dict_data["scope"], "title": title, "link": dict_data["links"][0]["href"]}
        else:
          single_data = {"id": dict_data["id"], "type": dict_data["group"], "scope": dict_data["scope"], "title": title, "link": dict_data["links"]}
      elif dict_data.get('body') is not None:
        message_and_body = (dict_data["message"] + dict_data["body"]).replace('"', '')
        match = re.search(r'(.+)\((#.+?)\)\s*(.+?)\((#.+?)\)', message_and_body)
        if match:
          title = re.sub(r'.+:\s*', '', match.group(3)) + ' (' + match.group(4) + ') (' + match.group(2) + ')'
          single_data = {"id": dict_data["id"], "type": dict_data["group"], "scope": dict_data["scope"], "title": title, "link": dict_data["links"][1]["href"]}
        else:
          single_data = {"id": dict_data["id"], "type": dict_data["group"], "scope": dict_data["scope"], "title": title, "link": dict_data["links"][0]["href"]}
      else:
        single_data = {"id": dict_data["id"], "type": dict_data["group"], "scope": dict_data["scope"], "title": title, "link": dict_data["links"][0]["href"]}
    data.append(single_data)

print(data)

json_file = open(path, mode="w")
json.dump(data, json_file, indent=2, ensure_ascii=False)
json_file.close()
