import 'package:event_app_mobile/services/feedbackService.dart';
import 'package:flutter/material.dart';

class UserFeedbackPage extends StatefulWidget {
  const UserFeedbackPage({Key? key}) : super(key: key);

  @override
  _UserFeedbackPageState createState() => _UserFeedbackPageState();
}

class _UserFeedbackPageState extends State<UserFeedbackPage> {
  TextEditingController _feedbackController = TextEditingController();
  String _message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 5,
            ),
            Text('Add Feedback',style: TextStyle(color:  Color(0xFFFFFFFF),fontWeight: FontWeight.bold),),
          ],
        ),
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon:Icon(Icons.arrow_back_ios_new,color:  Color(
            0xFFFFFFFF),)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _feedbackController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Enter your feedback here...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String feedback = _feedbackController.text;
                if (feedback.isNotEmpty) {
                  String result = await FeedbackService.addFeedback(feedback);
                  setState(() {
                    _message = result;
                  });
                } else {
                  setState(() {
                    _message = 'Please enter your feedback';
                  });
                }
              },
              child: Text('Submit Feedback'),
            ),
            SizedBox(height: 20),
            Text(
              _message,
              style: TextStyle(
                color: _message.startsWith('Error') ? Colors.red : Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
