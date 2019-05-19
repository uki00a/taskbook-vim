from .base import Base as BaseSource
from ..kind.base import Base as BaseKind

class Source(BaseSource):
    def __init__(self, vim):
        super().__init__(vim)
        self.name = 'taskbook'
        self.kind = Item(vim)
        self.vim = vim

    def gather_candidates(self, context):
        return [self.__build_candidate(x) for x in self.vim.eval('values(taskbook#items#load_from_storage())')]

    def __build_candidate(self, item):
        return {
            'word': self.__item_to_word(item),
            'action__id': self.vim.call('taskbook#item#id', item)
        }

    def __item_to_word(self, item):
        prefix = "[x]" if self.vim.call('taskbook#item#is_complete', item) else "[ ]"
        return prefix + self.vim.call('taskbook#item#to_string', item)

class Item(BaseKind):
    def __init__(self, vim):
        super().__init__(vim)
        self.name = 'item'
        self.default_action = 'check'
        self.redraw_actions += ['check', 'delete']
        self.persist_actions += ['check', 'delete']

    def action_check(self, context):
        target = context['targets'][0]
        self.vim.call('taskbook#command#check', [target['action__id']])

    def action_delete(self, context):
        target = context['targets'][0]
        self.vim.call('taskbook#command#delete', [target['action__id']])

