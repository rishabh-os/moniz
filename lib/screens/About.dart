import "package:flutter/material.dart";
import "package:package_info_plus/package_info_plus.dart";
import "package:url_launcher/url_launcher.dart";

class About extends StatefulWidget {
  const About() : super();

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  String version = "0.0.0";

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        version = "${packageInfo.version}+${packageInfo.buildNumber}";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Card(
                child: Column(
                  children: [
                    Image.asset(
                      "assets/coin4.png",
                      height: 100,
                    ),
                    Text(
                      "Moniz",
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    Text("Version: $version"),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.code_rounded),
                title: const Text("Source code"),
                onTap: () => launchUrl(
                  Uri.parse(
                    "https://github.com/rishabh-os/moniz",
                  ),
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.privacy_tip_rounded),
                title: const Text("Privacy Policy"),
                onTap: () => launchUrl(
                  Uri.parse(
                    "https://gh-profile-rishabh-os.vercel.app/moniz-privacy-policy",
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Made by",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundImage: NetworkImage(
                    "https://avatars.githubusercontent.com/u/42971275?v=4&size=128",
                  ),
                ),
                title: const Text("Rishabh Wanjari"),
                onTap: () => launchUrl(
                  Uri.parse(
                    "https://github.com/rishabh-os",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
