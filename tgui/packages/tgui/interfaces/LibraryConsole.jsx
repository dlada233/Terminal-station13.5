import { map, sortBy } from 'common/collections';
import { classes } from 'common/react';
import { useState } from 'react';

import { useBackend, useLocalState } from '../backend';
import {
  Box,
  Button,
  Dropdown,
  Flex,
  Input,
  LabeledList,
  Modal,
  NoticeBox,
  NumberInput,
  Section,
  Stack,
  Table,
} from '../components';
import { Window } from '../layouts';
import { sanitizeText } from '../sanitize';

export const LibraryConsole = (props) => {
  const { act, data } = useBackend();
  const { display_lore } = data;
  return (
    <Window
      theme={display_lore ? 'spookyconsole' : ''}
      title="图书馆终端"
      width={880}
      height={520}
    >
      <Window.Content m="0">
        <Flex height="100%">
          <Flex.Item>
            <PopoutMenu />
          </Flex.Item>
          <Flex.Item grow position="relative" pl={1}>
            <PageDisplay />
          </Flex.Item>
        </Flex>
      </Window.Content>
    </Window>
  );
};

export const PopoutMenu = (props) => {
  const { act, data } = useBackend();
  const { screen_state, show_dropdown, display_lore } = data;
  return (
    <Section fill maxWidth={show_dropdown ? '150px' : '36px'}>
      <Stack vertical fill>
        <Stack.Item>
          <Button
            fluid
            fontSize="13px"
            onClick={() => act('toggle_dropdown')}
            icon={show_dropdown === 1 ? 'chevron-left' : 'chevron-right'}
            tooltip={!show_dropdown && '扩展'}
            content={!!show_dropdown && '折叠'}
          />
        </Stack.Item>
        <PopoutEntry id={1} icon="list" text="库存" />
        <PopoutEntry id={2} icon="calendar" text="借书" />
        <PopoutEntry id={3} icon="server" text="存档" />
        <PopoutEntry id={4} icon="upload" text="上传" />
        <PopoutEntry id={5} icon="print" text="打印" />
        {!!display_lore && (
          <PopoutEntry
            id={6}
            icon="question"
            text={screen_state === 6 ? 'Gur Fbeprere' : '禁忌学识'}
            color="black"
            font="copperplate"
          />
        )}
      </Stack>
    </Section>
  );
};

export const PageDisplay = (props) => {
  const { act, data } = useBackend();
  const { screen_state } = data;
  /* eslint-disable indent */
  /* eslint-disable operator-linebreak */
  return screen_state === 1 ? (
    <Inventory />
  ) : screen_state === 2 ? (
    <Checkout />
  ) : screen_state === 3 ? (
    <Archive />
  ) : screen_state === 4 ? (
    <Upload />
  ) : screen_state === 5 ? (
    <Print />
  ) : screen_state === 6 ? (
    <Forbidden />
  ) : null;
  /* eslint-enable indent */
  /* eslint-enable operator-linebreak */
};

export const Inventory = (props) => {
  const { act, data } = useBackend();
  const { inventory_page_count, inventory_page, has_inventory } = data;
  if (!has_inventory) {
    return <NoticeBox>找不到书籍档案. 更新你的库存!</NoticeBox>;
  }
  return (
    <Stack vertical justify="space-between" height="100%">
      <Stack.Item grow>
        <ScrollableSection header="书籍库存" contents={<InventoryDetails />} />
      </Stack.Item>
      <Stack.Item align="center">
        <PageSelect
          minimum_page_count={1}
          page_count={inventory_page_count}
          current_page={inventory_page}
          call_on_change={(value) =>
            act('switch_inventory_page', {
              page: value,
            })
          }
        />
      </Stack.Item>
    </Stack>
  );
};

export const InventoryDetails = (props) => {
  const { act, data } = useBackend();
  const inventory = sortBy(
    map(data.inventory, (book, i) => ({
      ...book,
      // Generate a unique id
      key: i,
    })),
    (book) => book.key,
  );
  return (
    <Section>
      <Table>
        <Table.Row header>
          <Table.Cell>移除</Table.Cell>
          <Table.Cell>标题</Table.Cell>
          <Table.Cell>作者</Table.Cell>
        </Table.Row>
        {inventory.map((book) => (
          <Table.Row key={book.key}>
            <Table.Cell>
              <Button
                color="bad"
                onClick={() =>
                  act('inventory_remove', {
                    book_id: book.ref,
                  })
                }
                icon="times"
              >
                清除记录
              </Button>
            </Table.Cell>
            <Table.Cell>{book.title}</Table.Cell>
            <Table.Cell>{book.author}</Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};

export const Checkout = (props) => {
  const { act, data } = useBackend();
  const { checkout_page, checkout_page_count } = data;

  const [checkoutBook, setCheckoutBook] = useLocalState('CheckoutBook', false);
  return (
    <Stack vertical height="100%" justify="space-between">
      <Stack.Item grow>
        <Stack vertical height="100%">
          <Stack.Item grow>
            <ScrollableSection
              header="借出书籍"
              contents={<CheckoutEntries />}
            />
          </Stack.Item>
          <Stack.Item align="center">
            <PageSelect
              minimum_page_count={1}
              page_count={checkout_page_count}
              current_page={checkout_page}
              call_on_change={(value) =>
                act('switch_checkout_page', {
                  page: value,
                })
              }
            />
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          icon="barcode"
          content="借出书籍"
          fontSize="20px"
          onClick={() => setCheckoutBook(true)}
        />
      </Stack.Item>
      {!!checkoutBook && <CheckoutModal />}
    </Stack>
  );
};

export const CheckoutEntries = (props) => {
  const { act, data } = useBackend();
  const { checkouts, has_checkout } = data;

  if (!has_checkout) {
    return null;
  }
  return (
    <Table>
      <Table.Row header>
        <Table.Cell>登记</Table.Cell>
        <Table.Cell>标题</Table.Cell>
        <Table.Cell>作者</Table.Cell>
        <Table.Cell>借书人</Table.Cell>
        <Table.Cell>时间剩余</Table.Cell>
      </Table.Row>
      {checkouts.map((entry) => (
        <Table.Row key={entry.id}>
          <Table.Cell>
            <Button
              onClick={() =>
                act('checkin', {
                  checked_out_id: entry.ref,
                })
              }
              icon="box-open"
            />
          </Table.Cell>
          <Table.Cell>{entry.title}</Table.Cell>
          <Table.Cell>{entry.author}</Table.Cell>
          <Table.Cell>{entry.borrower}</Table.Cell>
          <Table.Cell backgroundColor={entry.overdue ? 'bad' : 'good'}>
            {entry.overdue ? '超时' : entry.due_in_minutes + ' 分钟'}
          </Table.Cell>
        </Table.Row>
      ))}
    </Table>
  );
};

const CheckoutModal = (props) => {
  const { act, data } = useBackend();
  const inventory = sortBy(
    map(data.inventory, (book, i) => ({
      ...book,
      // Generate a unique id
      key: i,
    })),
    (book) => book.key,
  );

  const [checkoutBook, setCheckoutBook] = useLocalState('CheckoutBook', false);
  const [bookName, setBookName] = useState('插入书籍名称...');
  const [checkoutee, setCheckoutee] = useState('接收方');
  const [checkoutPeriod, setCheckoutPeriod] = useState(5);
  return (
    <Modal width="500px">
      <Box fontSize="20px" pb={1}>
        你确定要借出这本书吗?
      </Box>
      <Dropdown
        over
        mb={1.7}
        width="100%"
        selected={bookName}
        options={inventory.map((book) => book.title)}
        value={bookName}
        onSelected={(e) => setBookName(e)}
      />
      <LabeledList>
        <LabeledList.Item label="借给">
          <Input
            width="160px"
            value={checkoutee}
            onChange={(e, value) => setCheckoutee(value)}
          />
        </LabeledList.Item>
        <LabeledList.Item label="借阅期限">
          <NumberInput
            value={checkoutPeriod}
            unit=" 分钟"
            minValue={1}
            step={1}
            stepPixelSize={10}
            onChange={(e, value) => setCheckoutPeriod(value)}
          />
        </LabeledList.Item>
      </LabeledList>
      <Stack justify="center" align="center" pt={1}>
        <Stack.Item>
          <Button
            icon="upload"
            content="借出"
            fontSize="16px"
            color="good"
            onClick={() => {
              setCheckoutBook(false);
              act('checkout', {
                book_name: bookName,
                loaned_to: checkoutee,
                checkout_time: checkoutPeriod,
              });
            }}
            lineHeight={2}
          />
        </Stack.Item>
        <Stack.Item>
          <Button
            icon="times"
            content="返回"
            fontSize="16px"
            color="bad"
            onClick={() => setCheckoutBook(false)}
            lineHeight={2}
          />
        </Stack.Item>
      </Stack>
    </Modal>
  );
};

export const Archive = (props) => {
  const { act, data } = useBackend();
  const { can_connect, can_db_request, page_count, our_page } = data;
  if (!can_connect) {
    return <NoticeBox>无法检索书籍目录，请与你的系统管理员取得联系.</NoticeBox>;
  }
  return (
    <Stack vertical justify="space-between" height="100%">
      <Stack.Item grow>
        <ScrollableSection header="远程存档" contents={<SearchAndDisplay />} />
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

export const SearchAndDisplay = (props) => {
  const { act, data } = useBackend();
  const {
    search_categories = [],
    book_id,
    title,
    category,
    author,
    params_changed,
    can_db_request,
  } = data;
  const records = sortBy(
    map(data.pages, (record, i) => ({
      ...record,
      // Generate a unique id
      key: i,
    })),
    (record) => record.key,
  );

  return (
    <Box>
      <Stack justify="space-between">
        <Stack.Item pb={0.6}>
          <Stack>
            <Stack.Item>
              <Input
                value={book_id}
                placeholder={book_id === null ? 'ID' : book_id}
                mt={0.5}
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
                width="120px"
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
                placeholder={title || '标题'}
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
                placeholder={author || '作者'}
                mt={0.5}
                onChange={(e, value) =>
                  act('set_search_author', {
                    author: value,
                  })
                }
              />
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item>
          <Button
            disabled={!can_db_request}
            textAlign="right"
            onClick={() => act('search')}
            color={params_changed ? 'good' : ''}
            icon="book"
          >
            Search
          </Button>
          <Button
            disabled={!can_db_request}
            textAlign="right"
            onClick={() => act('clear_data')}
            color="bad"
            icon="fire"
          >
            Reset Search
          </Button>
        </Stack.Item>
      </Stack>
      <Table>
        <Table.Row>
          <Table.Cell fontSize={1.5}>#</Table.Cell>
          <Table.Cell fontSize={1.5}>目录</Table.Cell>
          <Table.Cell fontSize={1.5}>标题</Table.Cell>
          <Table.Cell fontSize={1.5}>作者</Table.Cell>
        </Table.Row>
        {records.map((record) => (
          <Table.Row key={record.key}>
            <Table.Cell>
              <Button
                onClick={() =>
                  act('print_book', {
                    book_id: record.id,
                  })
                }
                icon="print"
              >
                {record.id}
              </Button>
            </Table.Cell>
            <Table.Cell>{record.category}</Table.Cell>
            <Table.Cell>{record.title}</Table.Cell>
            <Table.Cell>{record.author}</Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Box>
  );
};

export const Upload = (props) => {
  const { act, data } = useBackend();
  const {
    active_newscaster_cooldown,
    cache_author,
    cache_content,
    cache_title,
    can_db_request,
    has_cache,
    has_scanner,
    cooldown_string,
  } = data;
  const [uploadToDB, setUploadToDB] = useLocalState('UploadDB', false);
  if (!has_scanner) {
    return <NoticeBox>附近没有检测到扫描仪，请建造一台以继续.</NoticeBox>;
  }
  if (!has_cache) {
    return <NoticeBox>扫描一本书上传.</NoticeBox>;
  }
  const contentHtml = {
    __html: sanitizeText(cache_content),
  };
  return (
    <>
      <Stack vertical height="100%">
        <Stack.Item>
          <Box fontSize="20px" textAlign="center" pt="6px">
            当前扫描缓存
          </Box>
        </Stack.Item>
        <Stack.Item grow>
          <Stack vertical height="100%">
            <Stack.Item>
              <Stack justify="center">
                <Stack.Item>
                  <Box pt={1} fontSize={'20px'}>
                    标题:
                  </Box>
                </Stack.Item>
                <Stack.Item>
                  <Input
                    fontSize="20px"
                    value={cache_title}
                    placeholder={cache_title || 'Title'}
                    mt={0.5}
                    width={22}
                    onChange={(e, value) =>
                      act('set_cache_title', {
                        title: value,
                      })
                    }
                  />
                </Stack.Item>
                <Stack.Item>
                  <Box pt={1} fontSize="20px">
                    作者:
                  </Box>
                </Stack.Item>
                <Stack.Item>
                  <Input
                    fontSize="20px"
                    value={cache_author}
                    placeholder={cache_author || 'Author'}
                    mt={0.5}
                    onChange={(e, value) =>
                      act('set_cache_author', {
                        author: value,
                      })
                    }
                  />
                </Stack.Item>
              </Stack>
            </Stack.Item>
            <Stack.Item grow>
              <Section
                fill
                scrollable
                preserveWhitespace
                fontSize="15px"
                title="内容:"
              >
                <Box dangerouslySetInnerHTML={contentHtml} />
              </Section>
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item>
          <Stack>
            <Stack.Item grow>
              <Button
                disabled={!active_newscaster_cooldown}
                fluid
                tooltip={
                  active_newscaster_cooldown
                    ? '发送你的书到新闻广播频道.'
                    : '请等待 ' + cooldown_string + ' 在将书发送至新闻广播前!'
                }
                tooltipPosition="top"
                icon="newspaper"
                content="新闻广播"
                fontSize="30px"
                lineHeight={2}
                textAlign="center"
                onClick={() => act('news_post')}
              />
            </Stack.Item>
            <Stack.Item grow>
              <Button
                disabled={!can_db_request}
                fluid
                icon="server"
                content="存档"
                fontSize="30px"
                lineHeight={2}
                textAlign="center"
                onClick={() => setUploadToDB(true)}
              />
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
      {!!uploadToDB && <UploadModal />}
    </>
  );
};

const UploadModal = (props) => {
  const { act, data } = useBackend();

  const { upload_categories, default_category, can_db_request } = data;
  const [uploadToDB, setUploadToDB] = useLocalState('UploadDB', false);
  const [uploadCategory, setUploadCategory] = useState('');

  const display_category = uploadCategory || default_category;
  return (
    <Modal width="650px">
      <Box fontSize="20px" pb={2}>
        你确定想将这本书上传到数据库中吗?
      </Box>
      <LabeledList>
        <LabeledList.Item label="Category">
          <Dropdown
            options={upload_categories}
            selected={display_category}
            onSelected={(value) => setUploadCategory(value)}
          />
        </LabeledList.Item>
      </LabeledList>
      <Stack justify="center" align="center" pt={2}>
        <Stack.Item>
          <Button
            disabled={!can_db_request}
            icon="upload"
            content="上传至数据库"
            fontSize="18px"
            color="good"
            onClick={() => {
              setUploadToDB(false);
              act('upload', {
                category: display_category,
              });
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
            onClick={() => setUploadToDB(false)}
            lineHeight={2}
          />
        </Stack.Item>
      </Stack>
    </Modal>
  );
};

export const Print = (props) => {
  const { act, data } = useBackend();
  const { deity, religion, bible_name, bible_sprite, posters } = data;
  const [selectedPoster, setSelectedPoster] = useState(posters[0]);

  return (
    <Stack vertical fill>
      <Stack.Item grow>
        <Stack fill>
          <Stack.Item width="50%">
            <Section fill scrollable>
              {posters.map((poster) => (
                <div
                  key={poster}
                  title={poster}
                  className={classes([
                    'Button',
                    'Button--fluid',
                    'Button--color--transparent',
                    'Button--ellipsis',
                    selectedPoster &&
                      poster === selectedPoster &&
                      'Button--selected',
                  ])}
                  onClick={() => setSelectedPoster(poster)}
                >
                  {poster}
                </div>
              ))}
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Stack vertical height="100%">
              <Stack.Item
                textAlign="center"
                fontSize="25px"
                italic
                bold
                textColor="#0b94c4"
              >
                {bible_name}
              </Stack.Item>
              <Stack.Item textAlign="center" fontSize="22px" textColor="purple">
                以{deity}的名义
              </Stack.Item>
              <Stack.Item textAlign="center" fontSize="22px" textColor="purple">
                看在{religion}的份上
              </Stack.Item>
              <Stack.Item align="center">
                <Box className={classes(['bibles224x224', bible_sprite])} />
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item>
        <Stack justify="space-between">
          <Stack.Item grow>
            <Button
              fluid
              icon="scroll"
              content="海报"
              fontSize="30px"
              lineHeight={2}
              textAlign="center"
              onClick={() =>
                act('print_poster', {
                  poster_name: selectedPoster,
                })
              }
            />
          </Stack.Item>
          <Stack.Item grow>
            <Button
              fluid
              icon="cross"
              content="圣经"
              fontSize="30px"
              lineHeight={2}
              textAlign="center"
              onClick={() => act('print_bible')}
            />
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};

const ForbiddenModal = (props) => {
  const { act, data } = useBackend();
  return (
    <Modal>
      <Box className="LibraryComputer__CultText" fontSize="28px">
        访问禁忌知识库 v 1.3:
      </Box>
      <Box className="LibraryComputer__CultText" pt={0.4}>
        你确定要继续吗?
      </Box>
      <Box className="LibraryComputer__CultText" pt={0.2} bold>
        EldritchRelics Inc. 不对此选择引发的可能后果负责
      </Box>
      <Stack justify="center" align="center">
        <Stack.Item>
          <Button
            className="LibraryComputer__CultText"
            fluid
            icon="check"
            content="同意"
            color="good"
            fontSize="20px"
            onClick={() => act('lore_spawn')}
            lineHeight={2}
          />
        </Stack.Item>
        <Stack.Item>
          <Button
            className="LibraryComputer__CultText"
            fluid
            icon="times"
            content="拒绝"
            color="bad"
            fontSize="20px"
            onClick={() => act('lore_deny')}
            lineHeight={2}
          />
        </Stack.Item>
      </Stack>
    </Modal>
  );
};

export const Forbidden = (props) => {
  const description =
    'Abf vqrnz cebprffhf pbzchgngvbanyvf fghqrer vapvcvrzhf\nCebprffhf pbzchgngvbanyrf fhag erf nofgenpgnr dhnr pbzchgngberf vapbyhag\nHg ribyihag, cebprffhf nyvn nofgenpgn dhnr qngn znavchyner qvphaghe\nRibyhgvbavf cebprffhf qvevtvghe cre rkrzcyhz erthynr cebtenzzngvf ibpngv\nUbzvarf cebtenzzngn nq cebprffhf erpgbf rssvpvhag\nEriren fcvevghf pbzchgngbevv phz vapnagnzragvf pbavhatvzhf\nCebprffhf pbzchgngvbanyvf rfg zhyghz fvzvyvf vqrnr irarsvpnr fcvevghf\nivqrev nhg gnatv aba cbgrfg\nAba rfg rk zngrevn pbzcbfvgn\nFrq vq cynpreng vcfhz\nAba cbgrfg bcrenev bchf vagryyrpghnyr\nErfcbaqrev cbgrfg\nZhaqhz nssvprer cbgrfg rebtnaqb crphavnz nq evcnz iry cre oenppuvhz \nebobgv snoevpnaqb zbqrenaqb\nPbafvyvvf hgvzhe cebprffvohf nhthenaqv fhag fvphg vapnagnzragn irarsvpvv';
  return (
    <Box className="LibraryComputer__CultNonsense" preserveWhitespace>
      {description}
      <ForbiddenModal />
    </Box>
  );
};

export const ScrollableSection = (props) => {
  const { header, contents } = props;

  return (
    <Section fill scrollable>
      <Box fontSize="20px" textAlign="center">
        {header}
      </Box>
      <Box position="relative" top="10px">
        {contents}
      </Box>
    </Section>
  );
};

export const PopoutEntry = (props) => {
  const { act, data } = useBackend();
  const { id, text, icon, color, font } = props;
  const { show_dropdown, screen_state } = data;
  const selected_color = color || 'good';
  const deselected_color = color || '';

  return (
    <Stack.Item>
      <Button
        fluid
        fontSize="13px"
        onClick={() =>
          act('set_screen', {
            screen_index: id,
          })
        }
        color={id === screen_state ? selected_color : deselected_color}
        fontFamily={font}
        icon={icon}
        tooltip={!show_dropdown && text}
        content={!!show_dropdown && text}
      />
    </Stack.Item>
  );
};

export const PageSelect = (props) => {
  const {
    minimum_page_count,
    page_count,
    current_page,
    call_on_change,
    disabled,
  } = props;

  if (page_count === 1) {
    return null;
  }

  return (
    <Stack>
      <Stack.Item>
        <Button
          disabled={current_page === minimum_page_count || disabled}
          icon="angle-double-left"
          onClick={() => call_on_change(minimum_page_count)}
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          disabled={current_page === minimum_page_count || disabled}
          icon="chevron-left"
          onClick={() => call_on_change(current_page - 1)}
        />
      </Stack.Item>
      <Stack.Item>
        <Input
          placeholder={current_page + '/' + page_count}
          onChange={(e, value) => {
            // I am so sorry
            if (value !== '') {
              call_on_change(value);
              e.target.value = null;
            }
          }}
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          disabled={current_page === page_count || disabled}
          icon="chevron-right"
          onClick={() => call_on_change(current_page + 1)}
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          disabled={current_page === page_count || disabled}
          icon="angle-double-right"
          onClick={() => call_on_change(page_count)}
        />
      </Stack.Item>
    </Stack>
  );
};
