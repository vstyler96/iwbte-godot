extends Node

func save(path: String, data: Dictionary) -> bool:
  var file = FileAccess.open(path, FileAccess.WRITE)
  file.store_string(JSON.stringify(data))
  file.close()
  return file.get_error() == OK

func read(path: String) -> Dictionary:
  var file = FileAccess.open(path, FileAccess.READ)
  var data = JSON.parse_string(file.get_as_text())
  file.close()
  return data

func saveEncrypted(path: String, data: Dictionary) -> bool:
  var cipher = Cipher.new()
  var raw = JSON.stringify(data);
  var encrypted = cipher.encrypt(raw)
  var file = FileAccess.open(path, FileAccess.WRITE)
  file.store_string(encrypted)
  file.close()
  return file.get_error() == OK

func readEncrypted(path: String) -> Dictionary:
  var cipher = Cipher.new()

  var file = FileAccess.open(path, FileAccess.READ)
  var encrypted = file.get_as_text()
  file.close()

  var decrypted = cipher.decrypt(encrypted)
  var data = JSON.parse_string(decrypted)

  return data or {}
