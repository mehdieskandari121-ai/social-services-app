import 'package:flutter/material.dart';

void main() => runApp(const EskandariApp());

const ink = Color(0xFF14233B);
const accent = Color(0xFF1C8C82);
const canvas = Color(0xFFF4F6FA);

class EskandariApp extends StatelessWidget {
  const EskandariApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Eskandari AI OS',
    theme: ThemeData(useMaterial3: true, scaffoldBackgroundColor: canvas,
      colorScheme: ColorScheme.fromSeed(seedColor: accent),
      appBarTheme: const AppBarTheme(backgroundColor: ink, foregroundColor: Colors.white)),
    home: const Directionality(textDirection: TextDirection.rtl, child: CommandCenter()),
  );
}

class CommandCenter extends StatefulWidget {
  const CommandCenter({super.key});
  @override
  State<CommandCenter> createState() => _CommandCenterState();
}

class _CommandCenterState extends State<CommandCenter> {
  int tab = 0;
  final controller = TextEditingController();
  final projects = const [
    ProjectData('ملک‌یار', 'سامانه هوشمند مدیریت املاک', Icons.apartment_rounded, Color(0xFF287A72), 'در حال توسعه'),
    ProjectData('کاربای خودرو', 'بازار آنلاین خودرو و خدمات', Icons.directions_car_filled_rounded, Color(0xFF4775B8), 'در حال توسعه'),
    ProjectData('دفتر املاک ۱۳۱', 'فروش، فایلینگ و ارتباط با مشتری', Icons.business_rounded, Color(0xFFB17A35), 'فعال'),
    ProjectData('بازسازی و مدیریت پیمان', 'پروژه‌های اجرایی و قراردادها', Icons.construction_rounded, Color(0xFF8062A8), 'فعال'),
  ];

  @override
  Widget build(BuildContext context) {
    final titles = ['اتاق فرمان', 'پروژه‌ها', 'وظایف', 'مدیر هوش مصنوعی'];
    return Scaffold(
      appBar: AppBar(title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('ESKANDARI AI OS', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
        Text(titles[tab], style: const TextStyle(fontSize: 12, color: Colors.white70)),
      ])),
      body: SafeArea(child: IndexedStack(index: tab, children: [dashboard(), projectPage(), tasksPage(), assistantPage()])),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab, onDestinationSelected: (v) => setState(() => tab = v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'خانه'),
          NavigationDestination(icon: Icon(Icons.folder_open_outlined), selectedIcon: Icon(Icons.folder), label: 'پروژه‌ها'),
          NavigationDestination(icon: Icon(Icons.task_alt_outlined), selectedIcon: Icon(Icons.task_alt), label: 'وظایف'),
          NavigationDestination(icon: Icon(Icons.auto_awesome_outlined), selectedIcon: Icon(Icons.auto_awesome), label: 'هوش مصنوعی'),
        ]),
    );
  }

  Widget dashboard() => ListView(padding: const EdgeInsets.all(16), children: [
    Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(
      gradient: const LinearGradient(colors: [ink, Color(0xFF24486A)]), borderRadius: BorderRadius.circular(22)),
      child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('مرکز کنترل کسب‌وکارهای شما', style: TextStyle(color: Colors.white70)),
        SizedBox(height: 9), Text('همه‌چیز زیر نظر شماست.', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
        SizedBox(height: 8), Text('پروژه‌ها، وظایف و مدیران هوشمند در یک نقطه', style: TextStyle(color: Colors.white70, fontSize: 12)),
      ])),
    const SizedBox(height: 16),
    Row(children: [Expanded(child: metric('پروژه‌ها', '۴', Icons.folder_copy_outlined)), const SizedBox(width: 9),
      Expanded(child: metric('وظایف باز', '۰', Icons.pending_actions)), const SizedBox(width: 9),
      Expanded(child: metric('مدیران فعال', '۱', Icons.smart_toy_outlined))]),
    const SizedBox(height: 22), sectionTitle('پروژه‌های من', 'مشاهده همه', () => setState(() => tab = 1)),
    const SizedBox(height: 10), ...projects.map(projectTile),
    const SizedBox(height: 18), sectionTitle('دسترسی سریع', null, null), const SizedBox(height: 10),
    Row(children: [Expanded(child: quickAction(Icons.add_task, 'ثبت وظیفه', () => setState(() => tab = 2))),
      const SizedBox(width: 10), Expanded(child: quickAction(Icons.forum_outlined, 'دستور جدید', () => setState(() => tab = 3)))]),
  ]);

  Widget projectPage() => ListView(padding: const EdgeInsets.all(16), children: [
    sectionTitle('همه پروژه‌ها', '۴ پروژه', null), const SizedBox(height: 12), ...projects.map(projectTile),
    const Text('در نسخه بعدی: ایجاد پروژه، تعیین مدیر، بودجه، مهلت و اتصال ابزارها فعال می‌شود.',
      style: TextStyle(color: Colors.black54, height: 1.8)),
  ]);

  Widget tasksPage() => ListView(padding: const EdgeInsets.all(16), children: [
    sectionTitle('مرکز وظایف', 'نسخه اولیه', null), const SizedBox(height: 12),
    Container(padding: const EdgeInsets.all(22), decoration: cardDecoration(), child: const Column(children: [
      Icon(Icons.check_circle_outline_rounded, size: 42, color: accent), SizedBox(height: 12),
      Text('هنوز وظیفه‌ای ثبت نشده', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), SizedBox(height: 6),
      Text('در گام بعدی امکان ثبت، اولویت‌بندی، تعیین مسئول و پیگیری مهلت‌ها اضافه می‌شود.',
        textAlign: TextAlign.center, style: TextStyle(color: Colors.black54, height: 1.7)),
    ])),
  ]);

  Widget assistantPage() => ListView(padding: const EdgeInsets.all(16), children: [
    Container(padding: const EdgeInsets.all(18), decoration: cardDecoration(), child: const Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [CircleAvatar(backgroundColor: Color(0xFFE2F3F0), child: Icon(Icons.auto_awesome, color: accent)),
          SizedBox(width: 10), Text('مدیر کل هوشمند', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17))]),
        SizedBox(height: 14),
        Text('من نقطه شروع اتاق فرمان هستم. در نسخه متصل، دستور شما را تحلیل می‌کنم، به وظایف قابل پیگیری تبدیل می‌کنم و برای عملیات حساس تأیید می‌گیرم.',
          style: TextStyle(height: 1.9)),
        SizedBox(height: 10),
        Text('وضعیت: رابط کاربری اولیه؛ اتصال واقعی مدل و ابزارها هنوز انجام نشده است.',
          style: TextStyle(color: Colors.deepOrange, fontSize: 12, fontWeight: FontWeight.w600)),
      ])),
    const SizedBox(height: 14),
    TextField(controller: controller, minLines: 2, maxLines: 4, decoration: InputDecoration(
      hintText: 'مثلاً: وضعیت پروژه ملک‌یار را بررسی کن...', filled: true, fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none))),
    const SizedBox(height: 10),
    FilledButton.icon(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('اتصال مدیر هوشمند در مرحله بعد فعال می‌شود.'))),
      icon: const Icon(Icons.send_rounded), label: const Text('ارسال دستور'),
      style: FilledButton.styleFrom(backgroundColor: accent, padding: const EdgeInsets.all(14))),
  ]);

  Widget metric(String title, String value, IconData icon) => Container(padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
    decoration: cardDecoration(), child: Column(children: [Icon(icon, color: accent, size: 21), const SizedBox(height: 7),
      Text(value, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: ink)),
      Text(title, style: const TextStyle(fontSize: 11, color: Colors.black54))]));

  Widget sectionTitle(String title, String? trailing, VoidCallback? action) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: ink)),
      if (trailing != null) TextButton(onPressed: action, child: Text(trailing)),
    ]);

  Widget projectTile(ProjectData p) => Container(margin: const EdgeInsets.only(bottom: 10), decoration: cardDecoration(),
    child: ListTile(contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      leading: Container(width: 46, height: 46, decoration: BoxDecoration(color: p.color.withOpacity(.12), borderRadius: BorderRadius.circular(14)),
        child: Icon(p.icon, color: p.color)),
      title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(p.description, style: const TextStyle(fontSize: 11)),
      trailing: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: p.color.withOpacity(.1), borderRadius: BorderRadius.circular(20)),
          child: Text(p.status, style: TextStyle(color: p.color, fontSize: 10))),
        const SizedBox(height: 4), const Icon(Icons.chevron_left, size: 17, color: Colors.black38),
      ])));

  Widget quickAction(IconData icon, String label, VoidCallback onTap) => InkWell(onTap: onTap,
    borderRadius: BorderRadius.circular(16), child: Container(padding: const EdgeInsets.all(16),
      decoration: cardDecoration(), child: Row(children: [Icon(icon, color: accent), const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600))])));

  BoxDecoration cardDecoration() => BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(17),
    boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 12, offset: Offset(0, 4))]);
}

class ProjectData {
  final String name, description, status;
  final IconData icon;
  final Color color;
  const ProjectData(this.name, this.description, this.icon, this.color, this.status);
}
