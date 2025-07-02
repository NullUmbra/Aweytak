import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class DisclaimerScreenContent extends StatelessWidget { // Renamed class
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const DisclaimerScreenContent({ // Renamed constructor
    super.key,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = Provider.of<LanguageProvider>(context).isArabic;

    return AlertDialog( // Changed from Scaffold to AlertDialog
      title: Text(isArabic ? 'إخلاء المسؤولية الهام' : 'Important Disclaimer'),
      content: SingleChildScrollView( // Use SingleChildScrollView for the content
        child: Text(
          isArabic
              ? '''
هذا التطبيق (أويتك) يوفر معلومات حول الإسعافات الأولية لأغراض تعليمية وإرشادية فقط. المعلومات المقدمة هنا ليست بديلاً عن المشورة الطبية المهنية أو التشخيص أو العلاج.

في حالة الطوارئ الطبية، اتصل فوراً بخدمات الطوارئ المحلية أو اطلب المساعدة من أخصائي طبي مؤهل. لا تتجاهل أبداً المشورة الطبية المهنية أو تؤخر طلبها بسبب شيء قرأته في هذا التطبيق.

لا يتحمل مطورو هذا التطبيق أي مسؤولية عن أي إصابات أو أضرار قد تنجم عن استخدام أو سوء استخدام المعلومات المقدمة هنا. استخدم هذا التطبيق على مسؤوليتك الخاصة.

من خلال النقر على "أوافق"، فإنك تقر بأنك قد قرأت وفهمت هذا الإخلاء للمسؤولية وتوافق على شروطه.
'''
              : '''
This application (Aweytak) provides first aid information for educational and informational purposes only. The information provided herein is not a substitute for professional medical advice, diagnosis, or treatment.

In case of a medical emergency, immediately call your local emergency services or seek assistance from a qualified medical professional. Never disregard professional medical advice or delay in seeking it because of something you have read in this application.

The developers of this application assume no liability for any injuries or damages that may result from the use or misuse of the information provided herein. Use this application at your own risk.

By clicking "Agree," you acknowledge that you have read, understood, and agree to the terms of this disclaimer.
''',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: isArabic ? TextAlign.right : TextAlign.left,
        ),
      ),
      actions: [
        TextButton(
          onPressed: onReject, // Call the onReject callback
          child: Text(
            isArabic ? 'لا أوافق' : 'Disagree',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
        ElevatedButton(
          onPressed: onAccept, // Call the onAccept callback
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            isArabic ? 'أوافق وأتابع' : 'Agree and Proceed',
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }
}
