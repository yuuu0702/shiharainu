import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shiharainu/shared/widgets/widgets.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';

class ComponentShowcasePage extends StatefulWidget {
  const ComponentShowcasePage({super.key});

  @override
  State<ComponentShowcasePage> createState() => _ComponentShowcasePageState();
}

class _ComponentShowcasePageState extends State<ComponentShowcasePage> {
  String _segmentValue = 'option1';
  String _selectValue = 'option1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('コンポーネント素材集'),
        leading: AppButton.icon(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () => context.go('/dashboard'),
        ),
        actions: [
          AppBadge.info(text: 'DEBUG'),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'Buttons (ボタン)',
              Column(
                children: [
                  _buildRow([
                    Expanded(child: AppButton.primary(text: 'Primary Button')),
                    const SizedBox(width: 12),
                    Expanded(child: AppButton.outline(text: 'Outline Button')),
                  ]),
                  const SizedBox(height: 12),
                  _buildRow([
                    Expanded(
                      child: AppButton.secondary(text: 'Secondary Button'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: AppButton.ghost(text: 'Ghost Button')),
                  ]),
                  const SizedBox(height: 12),
                  _buildRow([
                    Expanded(child: AppButton.link(text: 'Link Button')),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppButton.primary(
                        text: 'Loading...',
                        isLoading: true,
                      ),
                    ),
                  ]),
                  const SizedBox(height: 12),
                  _buildRow([
                    AppButton.primary(text: 'Large', size: AppButtonSize.large),
                    const SizedBox(width: 12),
                    AppButton.primary(text: 'Medium'),
                    const SizedBox(width: 12),
                    AppButton.primary(text: 'Small', size: AppButtonSize.small),
                    const SizedBox(width: 12),
                    AppButton.icon(icon: const Icon(Icons.add, size: 20)),
                  ]),
                ],
              ),
            ),

            _buildSection(
              'Form Components (フォームコンポーネント)',
              Column(
                children: [
                  AppInput(
                    label: 'テキスト入力',
                    placeholder: 'プレースホルダーテキスト',
                    isRequired: true,
                    onChanged: (value) {}, // デモ用
                    prefixIcon: const Icon(Icons.email_outlined, size: 20),
                  ),
                  const SizedBox(height: 16),
                  AppInput(
                    label: 'パスワード入力',
                    placeholder: 'パスワードを入力',
                    obscureText: true,
                    prefixIcon: const Icon(Icons.lock_outline, size: 20),
                    suffixIcon: const Icon(
                      Icons.visibility_off_outlined,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppInput(
                    label: 'エラー状態',
                    placeholder: 'エラーのある入力',
                    errorText: 'この項目は必須です',
                  ),
                  const SizedBox(height: 16),
                  AppTextarea(
                    label: 'テキストエリア',
                    placeholder: '詳細説明を入力してください',
                    minLines: 3,
                    maxLines: 5,
                    isRequired: true,
                  ),
                  const SizedBox(height: 16),
                  AppSelect<String>(
                    label: 'セレクト',
                    value: _selectValue,
                    placeholder: '選択してください',
                    isRequired: true,
                    items: const [
                      DropdownMenuItem(value: 'option1', child: Text('オプション1')),
                      DropdownMenuItem(value: 'option2', child: Text('オプション2')),
                      DropdownMenuItem(value: 'option3', child: Text('オプション3')),
                    ],
                    onChanged: (value) =>
                        setState(() => _selectValue = value ?? 'option1'),
                  ),
                ],
              ),
            ),

            _buildSection(
              'Badges (バッジ)',
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: const [
                  AppBadge(text: 'Default'),
                  AppBadge.secondary(text: 'Secondary'),
                  AppBadge.success(text: 'Success'),
                  AppBadge.warning(text: 'Warning'),
                  AppBadge.info(text: 'Info'),
                  AppBadge.destructive(text: 'Destructive'),
                ],
              ),
            ),

            _buildSection(
              'Cards (カード)',
              Column(
                children: [
                  const AppCard(
                    child: AppCardHeader(
                      title: '基本カード',
                      subtitle: 'シンプルなカードコンポーネント',
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppCard.interactive(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('インタラクティブカードがタップされました')),
                      );
                    },
                    child: const AppCardHeader(
                      title: 'インタラクティブカード',
                      subtitle: 'クリック可能なカード',
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const AppCard(
                    isSelected: true,
                    child: AppCardHeader(
                      title: '選択状態のカード',
                      subtitle: '選択されているカード',
                      trailing: Icon(
                        Icons.check_circle,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            _buildSection(
              'Segmented Control (セグメントコントロール)',
              Column(
                children: [
                  AppSegmentedControl<String>(
                    options: const [
                      AppSegmentedControlOption(
                        value: 'option1',
                        label: 'オプション1',
                        icon: Icons.home,
                      ),
                      AppSegmentedControlOption(
                        value: 'option2',
                        label: 'オプション2',
                        icon: Icons.settings,
                      ),
                      AppSegmentedControlOption(
                        value: 'option3',
                        label: 'オプション3',
                        icon: Icons.info,
                      ),
                    ],
                    value: _segmentValue,
                    onChanged: (value) => setState(() => _segmentValue = value),
                  ),
                  const SizedBox(height: 16),
                  AppSegmentedControl<String>(
                    size: AppSegmentedControlSize.small,
                    options: const [
                      AppSegmentedControlOption(
                        value: 'small1',
                        label: 'Small 1',
                      ),
                      AppSegmentedControlOption(
                        value: 'small2',
                        label: 'Small 2',
                      ),
                    ],
                    value: 'small1',
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 16),
                  AppSegmentedControl<String>(
                    size: AppSegmentedControlSize.large,
                    options: const [
                      AppSegmentedControlOption(
                        value: 'large1',
                        label: 'Large 1',
                      ),
                      AppSegmentedControlOption(
                        value: 'large2',
                        label: 'Large 2',
                      ),
                    ],
                    value: 'large1',
                    onChanged: (value) {},
                  ),
                ],
              ),
            ),

            _buildSection(
              'Tabs (タブ)',
              SizedBox(
                height: 200, // 高さを固定してExpandedエラーを回避
                child: AppTabs(
                  items: [
                    AppTabItem(
                      label: 'タブ1',
                      icon: Icons.home,
                      content: const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24.0),
                          child: Text('タブ1のコンテンツ'),
                        ),
                      ),
                    ),
                    AppTabItem(
                      label: 'タブ2',
                      icon: Icons.settings,
                      content: const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24.0),
                          child: Text('タブ2のコンテンツ'),
                        ),
                      ),
                    ),
                    AppTabItem(
                      label: 'タブ3',
                      content: const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24.0),
                          child: Text('タブ3のコンテンツ'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            _buildSection(
              'Colors (カラーパレット)',
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildColorSwatch('Primary', AppTheme.primaryColor),
                  _buildColorSwatch('Destructive', AppTheme.destructiveColor),
                  _buildColorSwatch('Muted', AppTheme.mutedColor),
                  _buildColorSwatch('Ring (Focus)', AppTheme.ringColor),
                  _buildColorSwatch('Success', AppTheme.successColor),
                  _buildColorSwatch('Warning', AppTheme.warningColor),
                  _buildColorSwatch('Info', AppTheme.infoColor),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        content,
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildRow(List<Widget> children) {
    return Row(children: children);
  }

  Widget _buildColorSwatch(String name, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.mutedColor),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
        Text(
          '#${color.value.toRadixString(16).toUpperCase().substring(2)}',
          style: const TextStyle(fontSize: 10, color: AppTheme.mutedForeground),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
