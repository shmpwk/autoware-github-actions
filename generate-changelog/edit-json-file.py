import json
import ijson
with open("context.json", "r") as obj:
  gen = ijson.items(obj, "item.commits.item")
  data = []
  for idx, dict_data in enumerate(gen):
    if not idx % 100:
      print("")
    if dict_data["message"]:
      title = dict_data["message"].replace('"', '')
    if dict_data["links"]:
      single_data = {"id": dict_data["id"], "type": dict_data["group"], "scope": dict_data["scope"], "title": title, "link": dict_data["links"][0]["href"]}
    else:
      single_data = {"id": dict_data["id"], "type": dict_data["group"], "scope": dict_data["scope"], "title": title, "link": dict_data["links"]}
    data.append(single_data)
    # keys = list(single_data.keys())
    # values = list(single_data.values())
    # print(values)
    # values = json.loads(json.dumps(values).replace('"',''))
    # single_data = dict(zip(keys, values))

    #json_string = '{"key1": "value1", "key2": "value2"}'

    #data = json.loads(single_data)

    # new_data = {}
    # if single_data["title"
    # for key in single_data:
    #   print(single_data[key])
    #   if single_data[key] is not None and not single_data[key]:
    #     new_value = single_data[key].replace('"','')
    #     new_data[key] = new_value
    # json_string_without_quotes = json.dumps(new_data)

    # data.append(json_string_without_quotes)
print(data)
path = './context.json'
json_file = open(path, mode="w")
json.dump(data, json_file, indent=2, ensure_ascii=False)
json_file.close()
