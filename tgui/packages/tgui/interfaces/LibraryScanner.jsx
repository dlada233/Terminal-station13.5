import { useBackend } from '../backend';
import { Button, NoticeBox, Section, Stack } from '../components';
import { Window } from '../layouts';

export const LibraryScanner = (props) => {
  return (
    <Window title="图书馆扫描仪" width={350} height={150}>
      <BookScanning />
    </Window>
  );
};

const BookScanning = (props) => {
  const { act, data } = useBackend();
  const { has_book, has_cache, book } = data;
  if (!has_book && !has_cache) {
    return <NoticeBox>插入一本书来扫描</NoticeBox>;
  }
  return (
    <Stack direction="column" height="100%" justify="flex-end">
      <Stack.Item grow>
        <Section textAlign="center" height="100%" title={book.author}>
          {book.title}
        </Section>
      </Stack.Item>
      <Stack.Item>
        <Stack>
          <Stack.Item grow>
            <Button
              fluid
              textAlign="center"
              icon="eject"
              onClick={() => act('eject')}
              disabled={!has_book}
            >
              取出书籍
            </Button>
          </Stack.Item>
          <Stack.Item grow>
            <Button
              fluid
              textAlign="center"
              onClick={() => act('scan')}
              color="good"
              icon="qrcode"
              disabled={!has_book}
            >
              扫描书籍
            </Button>
          </Stack.Item>
          <Stack.Item grow>
            <Button
              fluid
              textAlign="center"
              icon="fire"
              onClick={() => act('clear')}
              color="bad"
              disabled={!has_cache}
            >
              清除缓存
            </Button>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};
