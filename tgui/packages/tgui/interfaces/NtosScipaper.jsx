import { useBackend } from '../backend';
import {
  BlockQuote,
  Box,
  Button,
  Collapsible,
  Dropdown,
  Input,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
  Table,
  Tabs,
} from '../components';
import { TableCell, TableRow } from '../components/Table';
import { NtosWindow } from '../layouts';

export const NtosScipaper = (props) => {
  return (
    <NtosWindow width={600} height={600}>
      <NtosWindow.Content scrollable>
        <NtosScipaperContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};

const PaperPublishing = (props) => {
  const { act, data } = useBackend();
  const {
    title,
    author,
    etAlia,
    abstract,
    fileList = [],
    expList = [],
    allowedTiers = [],
    allowedPartners = [],
    gains,
    selectedFile,
    selectedExperiment,
    tier,
    selectedPartner,
    coopIndex,
    fundingIndex,
  } = data;
  return (
    <>
      <Section title="提交表单">
        {fileList.length === 0 && (
          <NoticeBox>使用数据盘从压缩器或多普勒阵列下载文件</NoticeBox>
        )}
        <LabeledList>
          <LabeledList.Item
            label="文件 (必需)"
            buttons={
              <Button
                tooltip="所选文件包含我们论文的实验数据，必须存在于本地文件系统或数据软盘中才能访问."
                icon="info-circle"
              />
            }
          >
            <Box position="relative" top="8px">
              <Dropdown
                width="100%"
                options={Object.keys(fileList)}
                selected={selectedFile}
                onSelected={(ordfile_name) =>
                  act('select_file', {
                    selected_uid: fileList[ordfile_name],
                  })
                }
              />
            </Box>
          </LabeledList.Item>
          <LabeledList.Item
            label="实验 (必需)"
            buttons={
              <Button
                tooltip="我们要发表论文的题目，不同的主题会解锁不同的技术和潜在合作伙伴."
                icon="info-circle"
              />
            }
          >
            <Box position="relative" top="8px">
              <Dropdown
                width="100%"
                options={Object.keys(expList)}
                selected={selectedExperiment}
                onSelected={(experiment_name) =>
                  act('select_experiment', {
                    selected_expath: expList[experiment_name],
                  })
                }
              />
            </Box>
          </LabeledList.Item>
          <LabeledList.Item
            label="层级 (必需)"
            buttons={
              <Button
                tooltip="我们想要发布到的层级，更高的层级可以带来更好的奖励，但也意味着我们的数据将受到更严格的评估."
                icon="info-circle"
              />
            }
          >
            <Box position="relative" top="8px">
              <Dropdown
                width="100%"
                options={allowedTiers.map((number) => String(number))}
                selected={String(tier)}
                onSelected={(new_tier) =>
                  act('select_tier', {
                    selected_tier: Number(new_tier),
                  })
                }
              />
            </Box>
          </LabeledList.Item>
          <LabeledList.Item
            label="合作伙伴 (必需)"
            buttons={
              <Button
                tooltip="要与哪个组织合作，我们可以从合作伙伴感兴趣的技术领域中获得研究增益."
                icon="info-circle"
              />
            }
          >
            <Box position="relative" top="8px">
              <Dropdown
                width="100%"
                options={Object.keys(allowedPartners)}
                selected={selectedPartner}
                onSelected={(new_partner) =>
                  act('select_partner', {
                    selected_partner: allowedPartners[new_partner],
                  })
                }
              />
            </Box>
          </LabeledList.Item>
          <LabeledList.Item
            label="主要作者"
            buttons={
              <Button
                tooltip="多个"
                selected={etAlia}
                icon="users"
                onClick={() => act('et_alia')}
              />
            }
          >
            <Input
              mt={2}
              fluid
              value={author}
              onChange={(e, value) =>
                act('rewrite', {
                  author: value,
                })
              }
            />
          </LabeledList.Item>
          <LabeledList.Item label="标题">
            <Input
              fluid
              value={title}
              onChange={(e, value) =>
                act('rewrite', {
                  title: value,
                })
              }
            />
          </LabeledList.Item>
          <LabeledList.Item label="摘要">
            <Input
              fluid
              value={abstract}
              onChange={(e, value) =>
                act('rewrite', {
                  abstract: value,
                })
              }
            />
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section title="预期成果" key="rewards">
        <Stack fill>
          <Stack.Item grow>
            <Button
              tooltip="我们与合作伙伴的关系将得到多大改善？合作将用于解锁增益."
              icon="info-circle"
            />
            {' 合作: '}
            <BlockQuote>{gains[coopIndex - 1]}</BlockQuote>
          </Stack.Item>
          <Stack.Item grow>
            <Button
              tooltip="这篇论文发表之后，我们将得到多少资助."
              icon="info-circle"
            />
            {' 资助: '}
            <BlockQuote>{gains[fundingIndex - 1]}</BlockQuote>
          </Stack.Item>
        </Stack>
        <br />
        <Button
          lineHeight={3}
          icon="upload"
          textAlign="center"
          fluid
          onClick={() => act('publish')}
        >
          发表论文
        </Button>
      </Section>
    </>
  );
};

const PaperBrowser = (props) => {
  const { act, data } = useBackend();
  const { publishedPapers, coopIndex, fundingIndex } = data;
  if (publishedPapers.length === 0) {
    return <NoticeBox> 无发表的论文! </NoticeBox>;
  } else {
    return publishedPapers.map((paper) => (
      <Collapsible
        key={String(paper['experimentName'] + paper['tier'])}
        title={paper['title']}
      >
        <Section>
          <LabeledList>
            <LabeledList.Item label="题目">
              {paper['experimentName'] + ' - ' + paper['tier']}
            </LabeledList.Item>
            <LabeledList.Item label="作者">
              {paper['author'] + (paper.etAlia ? ' et al.' : '')}
            </LabeledList.Item>
            <LabeledList.Item label="合作伙伴">
              {paper['partner']}
            </LabeledList.Item>
            <LabeledList.Item label="收益">
              <LabeledList>
                <LabeledList.Item label="合作">
                  {paper['gains'][coopIndex - 1]}
                </LabeledList.Item>
                <LabeledList.Item label="资助">
                  {paper['gains'][fundingIndex - 1]}
                </LabeledList.Item>
              </LabeledList>
            </LabeledList.Item>
            <LabeledList.Item label="摘要">
              {paper['abstract']}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Collapsible>
    ));
  }
};
const ExperimentBrowser = (props) => {
  const { act, data } = useBackend();
  const { experimentInformation = [] } = data;
  return experimentInformation.map((experiment) => (
    <Section title={experiment.name} key={experiment.name}>
      {experiment.description}
      <br />
      <LabeledList>
        {Object.keys(experiment.target).map((tier) => (
          <LabeledList.Item
            key={tier}
            label={
              '最佳 ' +
              experiment.prefix +
              ' 数额 - 层级 ' +
              String(Number(tier) + 1)
            }
          >
            {experiment.target[tier] + ' ' + experiment.suffix}
          </LabeledList.Item>
        ))}
      </LabeledList>
    </Section>
  ));
};

const PartnersBrowser = (props) => {
  const { act, data } = useBackend();
  const {
    partnersInformation,
    coopIndex,
    fundingIndex,
    purchaseableBoosts = [],
    relations = [],
    visibleNodes = [],
  } = data;
  return partnersInformation.map((partner) => (
    <Section title={partner.name} key={partner.path}>
      <Collapsible title={'关系: ' + relations[partner.path]}>
        <LabeledList>
          <LabeledList.Item label="描述">{partner.flufftext}</LabeledList.Item>
          <LabeledList.Item label="关系">
            {relations[partner.path]}
          </LabeledList.Item>
          <LabeledList.Item label="合作奖励">
            {partner.multipliers[coopIndex - 1] + 'x'}
          </LabeledList.Item>
          <LabeledList.Item label="资助奖励">
            {partner.multipliers[fundingIndex - 1] + 'x'}
          </LabeledList.Item>
          <LabeledList.Item label="接受实验">
            {partner.acceptedExperiments.map((experiment_name) => (
              <Box key={experiment_name}>{experiment_name}</Box>
            ))}
          </LabeledList.Item>
          <LabeledList.Item label="技术共享">
            <Table>
              {partner.boostedNodes.map((node) => (
                <TableRow key={node.id}>
                  <TableCell>
                    {visibleNodes.includes(node.id) ? node.name : '未知技术'}
                  </TableCell>
                  <TableCell>
                    <Button
                      fluid
                      tooltipPosition="left"
                      textAlign="center"
                      disabled={
                        !purchaseableBoosts[partner.path].includes(node.id)
                      }
                      content="购买"
                      tooltip={'折扣: ' + node.discount}
                      onClick={() =>
                        act('purchase_boost', {
                          purchased_boost: node.id,
                          boost_seller: partner.path,
                        })
                      }
                    />
                  </TableCell>
                </TableRow>
              ))}
            </Table>
          </LabeledList.Item>
        </LabeledList>
      </Collapsible>
    </Section>
  ));
};

export const NtosScipaperContent = (props) => {
  const { act, data } = useBackend();
  const { currentTab, has_techweb } = data;
  return (
    <>
      {!has_techweb && (
        <Section title="未检测到techweb!" key="rewards">
          请将此应用程序同步到有效的techweb上以上传进度!
        </Section>
      )}
      <Tabs key="navigation" fluid align="center">
        <Tabs.Tab
          selected={currentTab === 1}
          onClick={() =>
            act('change_tab', {
              new_tab: 1,
            })
          }
        >
          {'发表论文'}
        </Tabs.Tab>
        <Tabs.Tab
          selected={currentTab === 2}
          onClick={() =>
            act('change_tab', {
              new_tab: 2,
            })
          }
        >
          {'出版物'}
        </Tabs.Tab>
        <Tabs.Tab
          selected={currentTab === 3}
          onClick={() =>
            act('change_tab', {
              new_tab: 3,
            })
          }
        >
          {'实验'}
        </Tabs.Tab>
        <Tabs.Tab
          selected={currentTab === 4}
          onClick={() =>
            act('change_tab', {
              new_tab: 4,
            })
          }
        >
          {'科研合作伙伴'}
        </Tabs.Tab>
      </Tabs>
      {currentTab === 1 && <PaperPublishing />}
      {currentTab === 2 && <PaperBrowser />}
      {currentTab === 3 && <ExperimentBrowser />}
      {currentTab === 4 && <PartnersBrowser />}
    </>
  );
};
