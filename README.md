# tf-datatypes
1. Primitive Types

These are the basic building blocks. Terraform has four primitive types:

**string
**
Represents textual data.

Example:

variable "name" {
  type    = string
  default = "Terraform"
}

**number
**
Represents numeric data (integer or float).

Example:

variable "instance_count" {
  type    = number
  default = 3
}

**bool**

Represents a Boolean value: true or false.

Example:

variable "enable_logging" {
  type    = bool
  default = true
}

**any**

Can hold any type of value (string, number, bool, list, map, etc.).

Useful for very flexible inputs.

Example:

variable "config" {
  type    = any
  default = { region = "us-east-1", enabled = true }
}

**list(type) – Ordered collection
**
Think of a list as a row of boxes where the order matters.

Every item must be the same type (all strings, all numbers, etc.).

You can pick an item by its position (index).

Example you wrote:

variable "servers" {
  type    = list(string)
  default = ["web1", "web2", "web3"]
}

What this means:

servers is a list of strings.

"web1" is at index 0, "web2" at index 1, "web3" at index 2.

You can use it like:

server_name = var.servers[1]  # Picks "web2"

Analogy: A row of mailboxes. Each mailbox holds one letter (all letters are strings), and you pick the mailbox by its position.

**2️⃣ set(type) – Unordered collection of unique items
**
A set is like a pile of unique things: no duplicates, order doesn’t matter.

Useful when you care about “what’s in it” but not the order.

Example:

variable "zones" {
  type    = set(string)
  default = ["us-east-1a", "us-east-1b"]
}

What this means:

zones has 2 unique zone names.

Terraform doesn’t guarantee the order, but it ensures no duplicates.

Analogy: A basket of fruits: you just care about what fruits are there, not the order.

**3️⃣ map(type) – Key-value pairs
**
A map is like a dictionary: each key points to a value.

Keys are always strings. Values can be the same type you define.

Example:

variable "ami_ids" {
  type = map(string)
  default = {
    us-east-1 = "ami-123456"
    us-west-2 = "ami-654321"
  }
}

What this means:

The key "us-east-1" maps to "ami-123456".

To use it:

ami = var.ami_ids["us-west-2"]  # Picks "ami-654321"

Analogy: Like a cabinet with labeled drawers. You open drawer "us-west-2" to get its content.

**4️⃣ object({ ... }) – Structured data
**
An object is like a record or row in a spreadsheet.

Each field has a name and a type, and you must provide all fields.

Example:

variable "server" {
  type = object({
    name   = string
    cpu    = number
    active = bool
  })
  default = {
    name   = "web-server"
    cpu    = 4
    active = true
  }
}

What this means:

server has 3 fields: name, cpu, active.

You access like:

server_name = var.server.name   # "web-server"
server_cpu  = var.server.cpu    # 4
server_active = var.server.active # true

Analogy: Think of a profile card: it has name, cpu, active written on it. You know exactly what info is in each field.

Visual Quick Cheat Sheet
Type	What it holds	Access Example	Analogy
list	Ordered same-type items	var.servers[1]	Row of mailboxes
set	Unordered unique items	Cannot rely on index	Basket of fruits
map	Key-value pairs	var.ami_ids["us-west-2"]	Cabinet with labeled drawers
object	Structured named fields	var.server.name	Profile card
