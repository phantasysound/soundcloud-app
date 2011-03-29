SETTINGS = YAML.load_file(File.join(Rails.root, "config", "settings.yml"))

HTTParty.get(SETTINGS["track"]).code == 200 ? SETTINGS["public"] = true : SETTINGS["public"] = false