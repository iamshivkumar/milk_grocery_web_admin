import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_web_admin/ui/pages/milk_mans/providers/write_milk_man_view_model_provider.dart';

class WriteMilkManView extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = Theme.of(context);
    final model = watch(writeMilkManViewModelProvider);
    return SizedBox(
      width: 400,
      child: Drawer(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: [
              ListTile(
                contentPadding: EdgeInsets.only(
                  left: 8,
                ),
                title: Text(
                  model.forEdit ? "UPDATE MILK MAN" : "ADD MILK MAN",
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: model.name,
                  onChanged: (v) => model.name = v,
                  onSaved: (v) => model.name = v!,
                  validator: (value) => value!.isEmpty ? "Enter Name" : null,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(labelText: "Name"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: model.mobile,
                  onChanged: (v) => model.mobile = v,
                  onSaved: (v) => model.mobile = v!,
                  validator: (value) =>
                      value!.isEmpty ? "Enter Mobile Number" : null,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(labelText: "Mobile Number"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: Column(
                  children: model.areas
                      .map(
                        (e) => ListTile(
                          leading: CloseButton(
                            onPressed: () => model.removeArea(e),
                          ),
                          title: Text(e),
                        ),
                      )
                      .toList(),
                ),
              ),
              Material(
                color: theme.primaryColorLight,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Form(
                    key: _formKey2,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: TextFormField(
                            initialValue: model.areaName,
                            validator: (value) =>
                                value!.isEmpty ? "Enter Area Name" : null,
                            onSaved: (v) => model.areaName = v!,
                            onChanged: (v) => model.areaName = v,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(labelText: "Area name"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: TextFormField(
                            initialValue: model.cityName,
                            validator: (value) =>
                                value!.isEmpty ? "Enter City Name" : null,
                            onSaved: (v) => model.cityName = v!,
                            onChanged: (v) => model.cityName = v,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(labelText: "City name"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: MaterialButton(
                            child: Text("ADD AREA"),
                            color: theme.primaryColor,
                            onPressed: () {
                              if (_formKey2.currentState!.validate()) {
                                _formKey2.currentState!.save();
                                model.addArea();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  color: theme.accentColor,
                  child: Text(model.forEdit ? "SAVE" : "ADD MILK MAN"),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                       model.writeMilkMan();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
