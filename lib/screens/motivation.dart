import 'package:flutter/material.dart';

class Motivation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text("You Can Do It"),
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  Text("If you do hard work, you will get closer to your goal"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  "“The Pessimist Sees Difficulty In Every Opportunity. The Optimist Sees Opportunity In Every Difficulty.”"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  "“You Learn More From Failure Than From Success. Don’t Let It Stop You. Failure Builds Character.”"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  "“People Who Are Crazy Enough To Think They Can Change The World, Are The Ones Who Do.” "),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  "“Knowing Is Not Enough; We Must Apply. Wishing Is Not Enough; We Must Do.”"),
            ),
          ],
        ),
      ),
    );
  }
}
