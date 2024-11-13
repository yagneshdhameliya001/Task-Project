import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Dock(
            items: const [
              Icons.person,
              Icons.message,
              Icons.call,
              Icons.camera,
              Icons.photo,
            ],
            builder: (icon) {
              return Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color:
                      Colors.primaries[icon.hashCode % Colors.primaries.length],
                ),
                child: Icon(icon, color: Colors.white, size: 32),
              );
            },
          ),
        ),
      ),
    );
  }
}

class Dock<T extends Object> extends StatefulWidget {
  const Dock({
    super.key,
    this.items = const [],
    required this.builder,
  });

  final List<T> items;
  final Widget Function(T) builder;

  @override
  State<Dock<T>> createState() => _DockState<T>();
}

class _DockState<T extends Object> extends State<Dock<T>> {
  late List<T> _items;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.items);
  }

  void _onItemDragged(T item, int fromIndex, int toIndex) {
    setState(() {
      _items.removeAt(fromIndex);
      _items.insert(toIndex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.black.withOpacity(0.1),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(_items.length, (index) {
          final item = _items[index];
          return _buildDraggableItem(item, index);
        }),
      ),
    );
  }

  Widget _buildDraggableItem(T item, int index) {
    return Draggable<T>(
      data: item,
      feedback: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: widget.builder(item)),
      childWhenDragging: const SizedBox(width: 64, height: 48),
      child: DragTarget<T>(
        onAcceptWithDetails: (receivedItem) {
          if (receivedItem != item) {
            final fromIndex = _items.indexOf(receivedItem.data);
            _onItemDragged(receivedItem.data, fromIndex, index);
          }
        },
        builder: (context, candidateData, rejectedData) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: widget.builder(item),
          );
        },
      ),
    );
  }
}
