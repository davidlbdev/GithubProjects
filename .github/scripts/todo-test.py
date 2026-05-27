import unittest
import io
from contextlib import redirect_stdout
from todo import Task, TaskPool


class TestTaskPool(unittest.TestCase):
    def setUp(self):
        self.task_pool = TaskPool()

    def test_add_task(self):
        task = Task("Test task")
        self.task_pool.add_task(task)
        self.assertEqual(len(self.task_pool.tasks), 1)
        self.assertEqual(self.task_pool.tasks[0].title, "Test task")

    def test_get_open_tasks(self):
        self.task_pool.populate()
        open_tasks = self.task_pool.get_open_tasks()
        self.assertTrue(all(task.status == "ToDo" for task in open_tasks))
        self.assertEqual(len(open_tasks), 3)

    def test_get_done_tasks(self):
        self.task_pool.populate()
        done_tasks = self.task_pool.get_done_tasks()
        self.assertTrue(all(task.status == "Done" for task in done_tasks))
        self.assertEqual(len(done_tasks), 3)


if __name__ == "__main__":
    suite = unittest.TestLoader().loadTestsFromTestCase(TestTaskPool)

    output = io.StringIO()
    runner = unittest.TextTestRunner(stream=output, verbosity=2)
    result = runner.run(suite)

    test_output = output.getvalue().splitlines()
    
    for line in test_output:
        if "... ok" in line:
            print(line)

    if not result.wasSuccessful():
        exit(1)
