import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_shortener/copy_to_clipboard.dart';
import 'package:url_shortener/link.dart';
import 'package:url_shortener/link.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key, required this.links});
  final List<Link> links;
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  void removeLink(Link link) {
    setState(() {
      widget.links.remove(link);
    });
  }

  void openUrl(String url) async {
    Uri uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: widget.links.length,
      itemBuilder: (context, index) {
        final String bittenLink = widget.links[index].bittenLink;
        final String originalLink = widget.links[index].originalLink;
        return ListTile(
          onTap: () {
            openUrl(bittenLink);
          },
          onLongPress: () {
            copyToClipboard(bittenLink);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Link is copied to clipboard"),
            ));
          },
          title: Text(bittenLink),
          subtitle: Text(originalLink),
          trailing: IconButton(
            onPressed: () {
              removeLink(widget.links[index]);
            },
            icon: const Icon(Ionicons.remove_circle_outline),
            color: Colors.red,
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(
        height: 0,
      ),
    );
  }
}
