import 'package:mobile_app_decubitus/constant.dart';
import 'package:flutter/material.dart';

class StartupPage extends StatelessWidget {
  const StartupPage({super.key});

  //Manage content
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor1,
      body: Padding(
        padding: const EdgeInsets.only(top: 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildLogo(),
            _buildContent(context),
          ],
        ),
      ),
    );
  }

  //Logo
  Widget _buildLogo() {
    return Image.asset(
      logoWithLabel,
      height: 350,
      width: 350,
    );
  }

  //Manage Title , Description for app and Button
  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 80),
      child: Column(
        children: [
          _buildTitle(),
          _buildDescription(),
          const SizedBox(height: 100),
          _buildGetStartedButton(context),
        ],
      ),
    );
  }

  //Title
  Widget _buildTitle() {
    return const Center(
      child: Text(
        'ยินดีต้อนรับสู่ DECUBITUS',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  //Description
  Widget _buildDescription() {
    return const SizedBox(
      width: 300,
      child: Text(
        'แอปพลิเคชันที่เป็นตัวช่วยการทำนายความรุนแรงของแผลกดทับพร้อมกับวิธีการดูแลเบื้องต้น',
        textAlign: TextAlign.center,
      ),
    );
  }

  //Button
  Widget _buildGetStartedButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _showPolicyDialog(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        textStyle: const TextStyle(fontSize: 25),
      ),
      child: const Text(
        'เริ่มต้นใช้งาน',
        style: TextStyle(color: backGroundColor1),
      ),
    );
  }

  void _showPolicyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool isChecked = false;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text(
                'นโยบายการใช้งาน',
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: const <Widget>[
                    Text(
                      'วันที่มีผลบังคับใช้: [ระบุวันที่]\n\n'
                      'แอปพลิเคชัน Decubitus ให้ความสำคัญกับความเป็นส่วนตัวของผู้ใช้งาน เราได้จัดทำนโยบายความเป็นส่วนตัวนี้ขึ้นเพื่ออธิบายถึงวิธีที่เรารวบรวม ใช้ เปิดเผย และปกป้องข้อมูลส่วนบุคคลของผู้ใช้ที่เกี่ยวข้องกับการใช้งานแอปพลิเคชัน\n\n'
                      '    1. การเก็บรวบรวมข้อมูลส่วนบุคคล\n'
                      'เราอาจเก็บรวบรวมข้อมูลส่วนบุคคลจากผู้ใช้เมื่อมีการลงทะเบียน การใช้งาน และการติดต่อผ่านแอปพลิเคชัน ซึ่งรวมถึง:\n'
                      '- ข้อมูลที่ระบุตัวตนได้: ชื่อ-นามสกุล, อีเมล, เบอร์โทรศัพท์, รหัสประจำตัวผู้ใช้\n'
                      '- ข้อมูลสุขภาพ: รายละเอียดเกี่ยวกับแผลกดทับ ระดับความรุนแรงของแผล ประวัติการรักษา\n'
                      '- ข้อมูลทางเทคนิค: ที่อยู่ IP, ประเภทอุปกรณ์, ระบบปฏิบัติการ, ข้อมูลบันทึก (Log Data)\n'
                      '- ข้อมูลการสื่อสาร: บันทึกการสนทนากับแพทย์และพยาบาล, ข้อมูลการติดตามการรักษา\n\n'
                      '    2. วัตถุประสงค์ในการใช้ข้อมูล\n'
                      'ข้อมูลที่เรารวบรวมจะถูกนำไปใช้เพื่อวัตถุประสงค์ดังต่อไปนี้:\n'
                      '- เพื่อให้บริการวิเคราะห์และจำแนกระดับแผลกดทับ\n'
                      '- เพื่อประสานงานการดูแลสุขภาพระหว่างผู้ใช้ แพทย์ และพยาบาล\n'
                      '- เพื่อปรับปรุงประสิทธิภาพและประสบการณ์ของผู้ใช้งาน\n'
                      '- เพื่อประมวลผลการตรวจวินิจฉัยด้วย AI\n'
                      '- เพื่อการวิเคราะห์ทางสถิติและการวิจัยเพื่อพัฒนาแอปพลิเคชัน\n'
                      '- เพื่อรักษาความปลอดภัยและป้องกันการละเมิดนโยบาย\n\n'
                      '    3. การเปิดเผยข้อมูลแก่บุคคลที่สาม\n'
                      'เราไม่เปิดเผยข้อมูลส่วนบุคคลของผู้ใช้แก่บุคคลที่สามโดยไม่ได้รับความยินยอม เว้นแต่ในกรณีต่อไปนี้:\n'
                      '- เมื่อได้รับความยินยอมจากผู้ใช้\n'
                      '- เมื่อจำเป็นต้องเปิดเผยเพื่อปฏิบัติตามกฎหมายหรือคำสั่งศาล\n'
                      '- เมื่อจำเป็นต้องให้ข้อมูลแก่บุคลากรทางการแพทย์เพื่อการดูแลรักษา\n'
                      '- เมื่อให้บริการผ่านผู้ให้บริการบุคคลที่สาม เช่น ระบบการวิเคราะห์ข้อมูล การโฮสต์ข้อมูล\n\n'
                      '    4. การเก็บรักษาข้อมูล\n'
                      'เราจะเก็บรักษาข้อมูลส่วนบุคคลของผู้ใช้งานเท่าที่จำเป็นสำหรับวัตถุประสงค์ที่ระบุไว้ในนโยบายนี้ โดยข้อมูลจะถูกเก็บรักษาอย่างปลอดภัยด้วยมาตรการป้องกันข้อมูลดังต่อไปนี้:\n'
                      '- การเข้ารหัสข้อมูล (Encryption) ทั้งในขณะส่งข้อมูลและจัดเก็บ\n'
                      '- การควบคุมสิทธิ์การเข้าถึงข้อมูล (Access Control)\n'
                      '- การตรวจสอบและบันทึกการเข้าถึงข้อมูล (Audit Log)\n\n'
                      '    5. สิทธิของผู้ใช้งาน\n'
                      'ผู้ใช้งานมีสิทธิ์ดังต่อไปนี้เกี่ยวกับข้อมูลส่วนบุคคลของตน:\n'
                      '- ขอเข้าถึงข้อมูลส่วนบุคคลที่เราเก็บรักษา\n'
                      '- ขอแก้ไขข้อมูลที่ไม่ถูกต้องหรือไม่สมบูรณ์\n'
                      '- ขอให้ลบข้อมูลส่วนบุคคลเมื่อไม่จำเป็นต้องเก็บรักษาอีกต่อไป\n'
                      '- ขอระงับการประมวลผลข้อมูลในบางกรณี\n\n'
                      '    6. คุกกี้ (Cookies) และเทคโนโลยีติดตาม\n'
                      'เราอาจใช้คุกกี้และเทคโนโลยีติดตามเพื่อวัตถุประสงค์ต่อไปนี้:\n'
                      '- เพื่อวิเคราะห์พฤติกรรมการใช้งานแอปพลิเคชัน\n'
                      '- เพื่อจัดเก็บการตั้งค่าของผู้ใช้\n'
                      '- เพื่อปรับปรุงประสบการณ์การใช้งาน\n\n'
                      '    7. การเปลี่ยนแปลงนโยบายความเป็นส่วนตัว\n'
                      'เราขอสงวนสิทธิ์ในการปรับปรุงและเปลี่ยนแปลงนโยบายความเป็นส่วนตัวนี้เป็นครั้งคราว เมื่อมีการเปลี่ยนแปลงสำคัญ เราจะมีการแจ้งให้ทราบผ่านแอปพลิเคชันหรือช่องทางการสื่อสารอื่นๆ\n\n'
                      '    8. ติดต่อเรา\n'
                      'หากมีคำถามหรือข้อกังวลเกี่ยวกับนโยบายความเป็นส่วนตัวนี้ สามารถติดต่อเราได้ที่:\n'
                      '- อีเมล: [ระบุอีเมล]\n'
                      '- เบอร์โทรศัพท์: [ระบุเบอร์โทรศัพท์]\n'
                      '- ที่อยู่: [ระบุที่อยู่]\n\n'
                      'ขอบคุณที่ไว้วางใจใช้บริการแอปพลิเคชัน Decubitus',
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                Row(
                  children: [
                    Checkbox(
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
                        });
                      },
                      activeColor: primaryColor,
                      checkColor: backGroundColor1,
                    ),
                    const Text('ฉันยอมรับนโยบายการใช้งาน'),
                  ],
                ),
                TextButton(
                  child: const Text('ยอมรับ'),
                  onPressed: isChecked
                      ? () {
                          Navigator.of(context).pop();
                          Navigator.pushReplacementNamed(context, '/login');
                        }
                      : null,
                  style: TextButton.styleFrom(foregroundColor: primaryColor),
                ),
                TextButton(
                  child: const Text('ไม่ยอมรับ'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(foregroundColor: errorColor),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
