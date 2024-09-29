import 'package:flutter/material.dart';
import 'dart:math';
import 'package:window_manager/window_manager.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  windowManager.setMinimumSize(const Size(480,800));
  windowManager.setMaximumSize(const Size(480,800));
  windowManager.setFullScreen(false);
  runApp( MatrixApp());
}

class MatrixApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Matrix App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MatrixHomePage(),
    );
  }
}

class MatrixHomePage extends StatefulWidget {
  @override
  _MatrixHomePageState createState() => _MatrixHomePageState();
}

class _MatrixHomePageState extends State<MatrixHomePage> {
  final TextEditingController _rowsController = TextEditingController();
  final TextEditingController _colsController = TextEditingController();
  List<List<TextEditingController>> matrixControllers = [];
  int rows = 0;
  int cols = 0;
  String leftValue = '';
  String rightValue = '';

  void _generateMatrix() {
    setState(() {
      rows = int.tryParse(_rowsController.text) ?? 0;
      cols = int.tryParse(_colsController.text) ?? 0;

      matrixControllers = List.generate(
        rows,
            (i) => List.generate(
          cols,
              (j) => TextEditingController(),
        ),
      );
    });
  }

  void _findMaxLeftRight() {
    int? maxValue;
    int? maxRow;
    int? maxCol;

    // Find the maximum value in the matrix
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        int? currentValue = int.tryParse(matrixControllers[i][j].text);
        if (currentValue != null && (maxValue == null || currentValue > maxValue)) {
          maxValue = currentValue;
          maxRow = i;
          maxCol = j;
        }
      }
    }

    if (maxRow != null && maxCol != null) {
      // Left value exists if the maxCol is not the first column
      if (maxCol > 0) {
        leftValue = matrixControllers[maxRow][maxCol - 1].text.isNotEmpty
            ? matrixControllers[maxRow][maxCol - 1].text
            : 'N/A';
      } else {
        leftValue = 'N/A';
      }

      // Right value exists if the maxCol is not the last column
      if (maxCol < cols - 1) {
        rightValue = matrixControllers[maxRow][maxCol + 1].text.isNotEmpty
            ? matrixControllers[maxRow][maxCol + 1].text
            : 'N/A';
      } else {
        rightValue = 'N/A';
      }

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dynamic Matrix'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _rowsController,
              decoration: InputDecoration(labelText: 'Enter number of rows'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _colsController,
              decoration: InputDecoration(labelText: 'Enter number of columns'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _generateMatrix,
              child: Text('Generate Matrix'),
            ),
            SizedBox(height: 20),
            if (rows > 0 && cols > 0)
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cols,
                  ),
                  itemCount: rows * cols,
                  itemBuilder: (context, index) {
                    int row = index ~/ cols;
                    int col = index % cols;
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextField(
                        controller: matrixControllers[row][col],
                        decoration: InputDecoration(border: OutlineInputBorder()),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _findMaxLeftRight,
              child: Text('Find Max, Left and Right'),
            ),
            SizedBox(height: 20),
            if (leftValue.isNotEmpty && rightValue.isNotEmpty)
              Column(
                children: [
                  Text('Left Value: $leftValue'),
                  Text('Right Value: $rightValue'),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

