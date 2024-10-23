import { map, sortBy } from 'common/collections';
import { capitalize } from 'common/string';
import { useState } from 'react';

import { useBackend, useLocalState } from '../backend';
import {
  Box,
  Button,
  Dropdown,
  Input,
  NoticeBox,
  Section,
  Stack,
  Table,
  TextArea,
} from '../components';
import { Window } from '../layouts';
import { PageSelect } from './LibraryConsole';

export const LibraryAdmin = (props) => {
  const [modifyMethod, setModifyMethod] = useLocalState('ModifyMethod', null);
  return (
    <Window title="图书管理终端" theme="admin" width={800} height={600}>
      {modifyMethod ? <ModifyPage /> : <BookListing />}
    </Window>
  );
};

type ListingData = {
  can_connect: boolean;
  can_db_request: boolean;
  our_page: number;
  page_count: number;
};

const BookListing = (props) => {
  const { act, data } = useBackend<ListingData>();
  const { can_connect, can_db_request, our_page, page_count } = data;
  if (!can_connect) {
    return (
      <NoticeBox>无法检索书籍目录，请联系你的系统管理员进行协助.</NoticeBox>
    );
  }
  return (
    <Stack fill vertical justify="space-between">
      <Stack.Item>
        <Box fillPositionedParent bottom="25px">
          <Window.Content scrollable>
            <SearchAndDisplay />
          </Window.Content>
        </Box>
      </Stack.Item>
      <Stack.Item align="center">
        <PageSelect
          minimum_page_count={1}
          page_count={page_count}
          current_page={our_page}
          disabled={!can_db_request}
          call_on_change={(value) =>
            act('switch_page', {
              page: value,
            })
          }
        />
      </Stack.Item>
    </Stack>
  );
};

type Book = {
  author: string;
  category: string;
  title: string;
  id: number;
};

type AdminBook = Book & {
  author_ckey: string;
  deleted: boolean;
};

type DisplayAdminBook = AdminBook & {
  key: number;
};

type DisplayData = {
  can_db_request: boolean;
  search_categories: string[];
  book_id: number;
  title: string;
  category: string;
  author: string;
  author_ckey: string;
  params_changed: boolean;
  view_raw: boolean;
  show_deleted: boolean;
  history: HistoryArray;
  pages: Book[];
};

const SearchAndDisplay = (props) => {
  const { act, data } = useBackend<DisplayData>();
  const [modifyMethod, setModifyMethod] = useLocalState('ModifyMethod', '');
  const [modifyTarget, setModifyTarget] = useLocalState('ModifyTarget', 0);
  const {
    can_db_request,
    search_categories = [],
    book_id,
    title,
    category,
    author,
    author_ckey,
    pages,
    params_changed,
    view_raw,
    show_deleted,
  } = data;
  const books = sortBy(
    map(
      pages,
      (book, i) =>
        ({
          ...book,
          // Generate a unique id
          key: i,
        }) as DisplayAdminBook,
    ),
    (book) => book.key,
  );
  return (
    <Section>
      <Stack justify="space-between">
        <Stack.Item>
          <Stack>
            <Stack.Item>
              <Input
                value={book_id}
                placeholder={book_id === null ? 'ID' : String(book_id)}
                width="70px"
                onChange={(e, value) =>
                  act('set_search_id', {
                    id: value,
                  })
                }
              />
            </Stack.Item>
            <Stack.Item>
              <Dropdown
                options={search_categories}
                selected={category}
                onSelected={(value) =>
                  act('set_search_category', {
                    category: value,
                  })
                }
              />
            </Stack.Item>
            <Stack.Item>
              <Input
                value={title}
                placeholder={title || 'Title'}
                mt={0.5}
                onChange={(e, value) =>
                  act('set_search_title', {
                    title: value,
                  })
                }
              />
            </Stack.Item>
            <Stack.Item>
              <Input
                value={author}
                placeholder={author || 'Author'}
                mt={0.5}
                onChange={(e, value) =>
                  act('set_search_author', {
                    author: value,
                  })
                }
              />
            </Stack.Item>
            <Stack.Item>
              <Input
                value={author_ckey}
                placeholder={author_ckey || 'Ckey'}
                mt={0.5}
                onChange={(e, value) =>
                  act('set_search_ckey', {
                    ckey: value,
                  })
                }
              />
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item>
          <Stack vertical>
            <Stack.Item>
              <Button
                disabled={!can_db_request}
                textAlign="right"
                onClick={() => act('refresh')}
                color={params_changed ? 'good' : ''}
                icon="rotate-right"
              >
                刷新
              </Button>
              <Button
                disabled={!can_db_request}
                textAlign="right"
                onClick={() => act('clear_data')}
                color="bad"
                icon="fire"
              >
                重置搜索
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                textAlign="right"
                onClick={() => act('toggle_raw')}
                color={view_raw ? 'purple' : 'blue'}
                icon={view_raw ? 'theater-masks' : 'glasses'}
                content={view_raw ? '未处理' : '正常'}
              />
              <Button
                textAlign="right"
                onClick={() => act('toggle_deleted')}
                color={show_deleted ? 'purple' : 'green'}
                icon={show_deleted ? 'trash' : 'mountain-sun'}
                content={show_deleted ? '全部' : '恢复'}
              />
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
      <Table>
        <Table.Row>
          <Table.Cell fontSize={1.5}>#</Table.Cell>
          <Table.Cell fontSize={1.5}>目录</Table.Cell>
          <Table.Cell fontSize={1.5}>标题</Table.Cell>
          <Table.Cell fontSize={1.5}>作者</Table.Cell>
          <Table.Cell fontSize={1.5}>C-Key</Table.Cell>
          <Table.Cell fontSize={1.5}>Un/Delete</Table.Cell>
        </Table.Row>
        {books.map((book) => (
          <Table.Row key={book.key}>
            <Table.Cell>
              <Button
                onClick={() =>
                  act('view_book', {
                    book_id: book.id,
                  })
                }
                icon="book-reader"
              >
                {book.id}
              </Button>
            </Table.Cell>
            <Table.Cell>{book.category}</Table.Cell>
            <Table.Cell>{book.title}</Table.Cell>
            <Table.Cell>{book.author}</Table.Cell>
            <Table.Cell>{book.author_ckey}</Table.Cell>
            <Table.Cell>
              {book.deleted ? (
                <Button
                  onClick={() => {
                    setModifyTarget(book.id);
                    setModifyMethod(ModifyTypes.Restore);
                    act('get_history', {
                      book_id: book.id,
                    });
                  }}
                  icon="undo"
                  color="blue"
                >
                  恢复
                </Button>
              ) : (
                <Button
                  onClick={() => {
                    setModifyTarget(book.id);
                    setModifyMethod(ModifyTypes.Delete);
                    act('get_history', {
                      book_id: book.id,
                    });
                  }}
                  icon="hammer"
                  color="violet"
                >
                  删除
                </Button>
              )}
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};

const ModifyTypes = {
  Delete: 'delete',
  Restore: 'restore',
};

type HistoryEntry = {
  // The id of this logged action
  id: number;
  // The book id this log applies to
  book: number;
  // The reason this action was enacted
  reason: string;
  // The admin who performed the action
  ckey: string;
  // The time of the action being performed
  datetime: string;
  // The action that ocurred
  action: string;
  // The ip address of the admin who performed the action
  ip_addr: string;
};

type HistoryArray = {
  [key: string]: HistoryEntry[];
};

type ModalData = {
  can_db_request: boolean;
  view_raw: boolean;
  history: HistoryArray;
};

const ModifyPage = (props) => {
  const { act, data } = useBackend<ModalData>();

  const { can_db_request, view_raw, history } = data;
  const [modifyMethod, setModifyMethod] = useLocalState('ModifyMethod', '');
  const [modifyTarget, setModifyTarget] = useLocalState('ModifyTarget', 0);
  const [reason, setReason] = useState('null');

  const entries = history[modifyTarget.toString()]
    ? history[modifyTarget.toString()].sort((a, b) => b.id - a.id)
    : [];

  return (
    <Window.Content scrollable>
      <NoticeBox>
        注意! 我们不会让你在游戏中完全删除书籍
        <br />
        你现在所做的事情只是让其他在本局内看不到此书籍.
        <br />
        如果你出于某种原因需要在游戏中完全删除书籍，请与数据库管理员联系.
      </NoticeBox>
      <Stack>
        <Stack.Item fontSize="25px" pb={2}>
          为什么你想要 {modifyMethod} 这本书?
        </Stack.Item>
        <Stack.Item fontSize="17px">
          <Button
            onClick={() =>
              act('view_book', {
                book_id: modifyTarget,
              })
            }
            icon="book-reader"
          >
            浏览
          </Button>
        </Stack.Item>
        <Stack.Item fontSize="17px">
          <Button
            textAlign="right"
            onClick={() => act('toggle_raw')}
            color={view_raw ? 'purple' : 'blue'}
            icon={view_raw ? 'theater-masks' : 'glasses'}
            content={view_raw ? '未处理' : '正常'}
          />
        </Stack.Item>
      </Stack>
      <TextArea
        fluid
        height="20vh"
        width="100%"
        backgroundColor="black"
        textColor="white"
        onChange={(e, value) => setReason(value)}
      />
      <Stack justify="center" align="center" pt={1} pb={1}>
        <Stack.Item>
          <Button
            disabled={!can_db_request}
            icon="upload"
            content={capitalize(modifyMethod)}
            fontSize="18px"
            color="good"
            onClick={() => {
              switch (modifyMethod) {
                case ModifyTypes.Delete:
                  act('hide_book', {
                    book_id: modifyTarget,
                    delete_reason: reason,
                  });
                  break;
                case ModifyTypes.Restore:
                  act('unhide_book', {
                    book_id: modifyTarget,
                    free_reason: reason,
                  });
                  break;
              }
              setModifyMethod('');
              setModifyTarget(0);
            }}
            lineHeight={2}
          />
        </Stack.Item>
        <Stack.Item>
          <Button
            icon="times"
            content="返回"
            fontSize="18px"
            color="bad"
            onClick={() => {
              setModifyMethod('');
              setModifyTarget(0);
            }}
            lineHeight={2}
          />
        </Stack.Item>
      </Stack>
      <Table>
        <Table.Row backgroundColor="rgba(0,0,0, 0.4)" header>
          <Table.Cell className="LibraryAdmin_RecordHeader">ID</Table.Cell>
          <Table.Cell className="LibraryAdmin_RecordHeader">行为</Table.Cell>
          <Table.Cell className="LibraryAdmin_RecordHeader">原因</Table.Cell>
          <Table.Cell className="LibraryAdmin_RecordHeader">
            管理员Key
          </Table.Cell>
          <Table.Cell className="LibraryAdmin_RecordHeader">
            日期时间
          </Table.Cell>
        </Table.Row>
        {entries.map((entry) => (
          <Table.Row
            key={entry.id}
            backgroundColor={get_action_color(entry.action)}
          >
            <Table.Cell className="LibraryAdmin_RecordCell">
              {entry.id}
            </Table.Cell>
            <Table.Cell className="LibraryAdmin_RecordCell">
              {capitalize(entry.action)}
            </Table.Cell>
            <Table.Cell
              className="LibraryAdmin_RecordCell"
              style={{
                whiteSpace: 'pre-wrap',
              }}
            >
              {entry.reason}
            </Table.Cell>
            <Table.Cell className="LibraryAdmin_RecordCell">
              {entry.ckey}
            </Table.Cell>
            <Table.Cell className="LibraryAdmin_RecordCell">
              {entry.datetime}
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Window.Content>
  );
};

const get_action_color = (reason: string) => {
  switch (reason) {
    case 'deleted':
      return 'rgba(255, 0, 0, 0.4)';
    case 'undeleted':
      return 'rgba(0, 120, 70, 0.4)';
    default:
      return 'rgba(0, 0, 0, 0.4)';
  }
};
