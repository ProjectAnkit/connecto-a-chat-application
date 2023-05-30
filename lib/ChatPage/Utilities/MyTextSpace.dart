import 'package:flutter/material.dart';

class MyMessageSpace extends StatelessWidget {
  const MyMessageSpace({super.key, required this.controller, required this.hint, this.ontap});

  final TextEditingController controller;
  final String hint;
  final Function()? ontap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0,left: 4,right: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width*0.75,
                decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(35),border: Border.all(color: Color.fromARGB(255, 209, 209, 209))),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 5),
                    child: TextFormField(
                      maxLength: null,
                      maxLines: 4,
                      minLines: 1,
                            controller: controller,
                            decoration:  InputDecoration(
                              border: InputBorder.none,
                              hintText: hint,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),

           InkWell(
                  onTap: ontap,
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(45)),
                    child: const Center(
                      child: Icon(Icons.send,color: Colors.white),
                    ),
                  ),
                )
        ],
      ),
    );
  }
}