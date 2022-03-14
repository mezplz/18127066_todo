class Todo {
  int id;
  String title;
  String time;
  String date;
  bool status;

  Todo(
      {required this.id,
      required this.title,
      required this.time,
      required this.date,
      required this.status});
      
  toJson() {
    return {
      "id": id,
      "title": title,
      "date": date,
      "time": time,
      "status": status
    };
  }

  fromJson(jsonData) {
    return Todo(
        id: jsonData['id'],
        title: jsonData['title'],
        date: jsonData['date'],
        time: jsonData['time'],
        status: jsonData['status']);
  }
}

// final todos = [
//   Todo(
//       id: 1,
//       title: 'Do homework',
//       time: '09:30',
//       date: '11/04/2022',
//       status: false),
//   Todo(
//       id: 2,
//       title: 'Do a project',
//       time: '14:30',
//       date: '14/03/2022',
//       status: true),
//   Todo(
//       id: 3,
//       title: 'Do homework',
//       time: '09:30',
//       date: '11/04/2022',
//       status: false),
//   Todo(
//       id: 4,
//       title: 'Run a project',
//       time: '09:30',
//       date: '11/04/2022',
//       status: false),
//   Todo(
//       id: 5,
//       title: 'Java test',
//       time: '09:30',
//       date: '11/04/2022',
//       status: true),
//   Todo(
//       id: 6,
//       title: 'Python test',
//       time: '09:30',
//       date: '14/03/2022',
//       status: false),
//   Todo(
//       id: 7,
//       title: 'Run a project',
//       time: '09:30',
//       date: '11/04/2022',
//       status: false),
//   Todo(
//       id: 8,
//       title: 'Swimming and running',
//       time: '09:30',
//       date: '14/03/2022',
//       status: false),
//   Todo(
//       id: 9,
//       title: 'Do homework',
//       time: '09:30',
//       date: '11/04/2022',
//       status: false),
//   Todo(
//       id: 10,
//       title: 'Do homework',
//       time: '09:30',
//       date: '11/04/2022',
//       status: false),
// ];
