import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:url_shortener/copy_to_clipboard.dart';
import 'package:url_shortener/link.dart';
import 'package:url_shortener/link.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.links});
  final List<Link> links;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final formKey = GlobalKey<FormState>();
  final urlTextController = TextEditingController();
  void biteLink(String url) async {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator.adaptive(),
                SizedBox(
                  height: 10,
                ),
                Text("Processing..")
              ],
            ),
          ),
        );
      },
    );
    try {
      final response =
          await Dio().get('https://api.shrtco.de/v2/shorten?url=$url');
      if (response.data['ok'] == true) {
        final data = response.data;
        final bittenLink = data['result']['full_short_link'];
        final originalLink = data['result']['original_link'];
        copyToClipboard(bittenLink);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Bitten Link is copied to clipboard"),
            backgroundColor: Colors.green,
          ));
          Navigator.of(context).pop();
        }
        final resultLink = 
            Link(originalLink: originalLink, bittenLink: bittenLink); 
        if(!widget.links.contains(resultLink)) {
          widget.links.insert(0, resultLink);
        }
      }
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Something went wrong please try again"),
            backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(15),
      children: [
        Image.asset(
          'assets/discussion.png',
          width: 300,
        ),
        Text(
          'A simple link but powerfull tool',
          style: Theme.of(context).textTheme.headline6,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          "Bite Link is a simple link shortner that helps yopu to shorten your link  and share it with your friends. Keep it brief, an easier way to share links",
          style: Theme.of(context).textTheme.subtitle1,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 10,
        ),
        Form(
          key: formKey,
          child: TextFormField(
            controller: urlTextController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              prefixIcon: const Icon(Ionicons.link),
              hintText: "Enter your url",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 8,
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return "Please Enter a url";
              }
              if (!value.startsWith('https://') && !value.startsWith("www.")) {
                return "Please Enter a valid url";
              }
              final urlRegex = RegExp(
                  r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$');
              if (!urlRegex.hasMatch(value)) {
                return "Please enter a valid url";
              }
              return null;
            },
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () {
            if (!formKey.currentState!.validate()) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Pleae enter a valid URL")));
              return;
            }
            biteLink(urlTextController.text);
          },
          child: const Text("Bite Link"),
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(
              vertical: 13,
              horizontal: 8.0,
            ),
          ),
        ),
      ],
    );
  }
}
