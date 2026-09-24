extends Node

const password = "qeDvENKGjDlnTfs7qNJlk1msvXU18SyG"

func save(path: String, data: Dictionary) -> bool:
  var file = FileAccess.open(path, FileAccess.WRITE)
  if file == null:
    return false
  file.store_string(JSON.stringify(data))
  var ok = file.get_error() == OK
  file.close()
  return ok

func read(path: String) -> Dictionary:
  var file = FileAccess.open(path, FileAccess.READ)
  if file == null:
    return {}
  var data = JSON.parse_string(file.get_as_text())
  file.close()
  return data if data is Dictionary else {}

func saveEncrypted(path: String, data: Dictionary) -> bool:
  var file = FileAccess.open_encrypted_with_pass(path, FileAccess.WRITE, password)
  if file == null:
    return false
  file.store_string(JSON.stringify(data))
  var ok = file.get_error() == OK
  file.close()
  return ok

func readEncrypted(path: String) -> Dictionary:
  var file = FileAccess.open_encrypted_with_pass(path, FileAccess.READ, password)
  if file == null:
    return {}
  var data = JSON.parse_string(file.get_as_text())
  file.close()
  return data if data is Dictionary else {}
