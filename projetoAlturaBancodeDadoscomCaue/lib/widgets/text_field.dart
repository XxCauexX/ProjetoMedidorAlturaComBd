import 'package:flutter/material.dart';

Widget textFormFieldP(
    BuildContext context, TextEditingController tx, String hint,
    {double? width}) {
  if (width == null) {
    return Padding(
        padding: const EdgeInsets.only(left: 30, top: 10, right: 30, bottom: 10),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 80,
          child: TextFormField(
            onFieldSubmitted: (value) {},
            validator: (value) => validator(value!),
            controller: tx,
            decoration: InputDecoration(
              label: Text(hint),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
          ),
        ));
  } else {
    return SizedBox(
      width: width,
      child: TextFormField(
        onFieldSubmitted: (value) {},
        validator: (value) => validator(value!),
        controller: tx,
        decoration: InputDecoration(
          hintText: hint,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}

validator(String text) {
  if (text.isEmpty) {
    return "Informe algum valor...";
  } else {
    return null;
  }
}
