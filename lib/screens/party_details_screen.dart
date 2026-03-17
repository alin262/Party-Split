import 'package:flutter/material.dart';
import 'package:partysplit/models/member.dart';
import 'package:partysplit/models/party.dart';
import 'package:partysplit/services/storage_services.dart';

class PartyDetailsScreen extends StatefulWidget {
  const PartyDetailsScreen({
    super.key,
    required this.party,
    required this.parties,
  });
  final Party party;
  final List<Party> parties;

  @override
  State<PartyDetailsScreen> createState() => _PartyDetailsScreenState();
}

class _PartyDetailsScreenState extends State<PartyDetailsScreen> {
  String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  void _deleteMember(Member member) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Delete Member",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red),
          ),
          content: Text(
            'Are you sure you want to delete: "${member.name}"',
            textAlign: TextAlign.center,
          ),
          actions: [
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.deepOrange[400],
              ),
              onPressed: () async {
                setState(() {
                  widget.party.members.remove(member);
                });
                await StorageServices.saveParties(widget.parties);
                Navigator.pop(context);
              },
              child: Text("Delete"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.deepOrange[400],
              ),
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void _addAmount(Member member) {
    final addcontroller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add cash", textAlign: TextAlign.center),

          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                member.amountPaid.toString(),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 8),
              Icon(Icons.add),
              SizedBox(width: 8),
              Flexible(
                child: TextField(
                  controller: addcontroller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            FilledButton(
              onPressed: () async {
                setState(() {
                  final amount = double.tryParse(addcontroller.text) ?? 0;
                  member.amountPaid = member.amountPaid + amount;
                });
                await StorageServices.saveParties(widget.parties);
                if (!mounted) return;
                Navigator.pop(context);
              },
              child: Text("ADD"),
            ),
          ],
        );
      },
    );
  }

  void _editAmount(Member member) {
    final editController = TextEditingController(
      text: member.amountPaid % 1 == 0
          ? member.amountPaid.toInt().toString()
          : member.amountPaid.toString(),
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Amount"),
          content: TextField(
            controller: editController,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: const InputDecoration(labelText: "Amount Paid"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  member.amountPaid = double.tryParse(editController.text) ?? 0;
                });
                await StorageServices.saveParties(widget.parties);
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _addMember() async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController amountController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(child: const Text("Add Member")),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                final amountText = amountController.text.trim();
                if (name.isNotEmpty) {
                  final amount = double.tryParse(amountText) ?? 0;
                  setState(() {
                    widget.party.members.add(
                      Member(name: name, amountPaid: amount),
                    );
                  });

                  await StorageServices.saveParties(widget.parties);
                  Navigator.pop(context);
                }
              },
              child: Text("save"),
            ),
          ],
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20),
              TextField(
                decoration: const InputDecoration(hintText: "Member name"),
                autofocus: true,
                textAlign: TextAlign.center,
                controller: nameController,
                textInputAction: TextInputAction.next,
                onEditingComplete: () {
                  FocusScope.of(context).nextFocus();
                },
              ),
              SizedBox(height: 20),
              TextField(
                decoration: const InputDecoration(
                  hintText: "Amount Paid",
                  border: OutlineInputBorder(),
                ),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                controller: amountController,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = 0;
    for (var member in widget.party.members) {
      totalAmount += member.amountPaid;
    }
    double equalShare = widget.party.members.isEmpty
        ? 0
        : totalAmount / widget.party.members.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.party.title.toUpperCase()),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Text("Members: ${widget.party.members.length}"),
                  Text("Total Spend: ₹$totalAmount"),
                  Text("Each should pay: ₹${equalShare.toStringAsFixed(2)}"),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.party.members.length,
              itemBuilder: (context, index) {
                final member = widget.party.members[index];

                double balance = member.amountPaid - equalShare;

                String statusText;
                Color statusColor;

                if (balance > 0) {
                  statusText = "Gets ₹${balance.toStringAsFixed(2)}";
                  statusColor = Colors.green;
                } else if (balance < 0) {
                  statusText = "Owes ₹${(-balance).toStringAsFixed(2)}";
                  statusColor = Colors.red;
                } else {
                  statusText = "Settled";
                  statusColor = Colors.grey;
                }

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    leading: CircleAvatar(
                      child: Text(member.name[0].toUpperCase()),
                    ),
                    title: Text(capitalizeFirst(member.name)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Paid: ₹${member.amountPaid}"),
                        Text(statusText, style: TextStyle(color: statusColor)),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _editAmount(member);
                          },
                        ),
                        IconButton(
                          onPressed: () {
                            _addAmount(member);
                          },
                          icon: const Icon(Icons.add_box_rounded),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _deleteMember(member);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMember,
        child: Icon(Icons.add),
      ),
    );
  }
}
