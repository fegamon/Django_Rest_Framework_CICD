from django.test import TestCase
from django.urls import reverse
from todo.models import Task


class TasksTest(TestCase):
    def test_view_tasks(self):
        response = self.client.get(reverse('task-list'))
        self.assertEqual(response.status_code, 200)

    def test_create_task(self):
        response = self.client.post(reverse('task-list'), {'title': 'New task'})
        self.assertEqual(response.status_code, 201)
        self.assertTrue(Task.objects.filter(title='New task').exists())

    def test_update_task(self):
        task = Task.objects.create(title='Old task')
        response = self.client.put(
            reverse('task-detail', args=[task.id]),
            {'title': 'New task'},
            content_type='application/json',
        )
        self.assertEqual(response.status_code, 200)
        self.assertTrue(Task.objects.filter(title='New task').exists())

    def test_delete_task(self):
        task = Task.objects.create(title='Task to delete')
        response = self.client.delete(reverse('task-detail', args=[task.id]))
        self.assertEqual(response.status_code, 204)
        self.assertFalse(Task.objects.filter(title='Task to delete').exists())
