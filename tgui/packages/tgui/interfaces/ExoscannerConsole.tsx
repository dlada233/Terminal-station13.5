import { useBackend } from '../backend';
import {
  BlockQuote,
  Box,
  Button,
  Icon,
  LabeledList,
  Modal,
  NoticeBox,
  Section,
  Stack,
} from '../components';
import { formatTime } from '../format';
import { Window } from '../layouts';

type SiteData = {
  name: string;
  ref: string;
  description: string;
  distance: number;
  band_info: Record<string, string>;
  revealed: boolean;
};

type ScanData = {
  scan_power: number;
  point_scan_eta: number;
  deep_scan_eta: number;
  point_scan_complete: boolean;
  deep_scan_complete: boolean;
  site_data: SiteData;
};

const ScanFailedModal = (props) => {
  const { act } = useBackend();
  return (
    <Modal>
      <Stack fill vertical>
        <Stack.Item>
          <Box color="bad">扫描失败!</Box>
        </Stack.Item>
        <Stack.Item>
          <Button content="确认" onClick={() => act('confirm_fail')} />
        </Stack.Item>
      </Stack>
    </Modal>
  );
};

const ScanSelectionSection = (props) => {
  const { act, data } = useBackend<ScanData>();
  const {
    scan_power,
    point_scan_eta,
    deep_scan_eta,
    point_scan_complete,
    deep_scan_complete,
    site_data,
  } = data;
  const site = site_data;

  const point_cost = scan_power > 0 ? formatTime(point_scan_eta, 'short') : '∞';
  const deep_cost = scan_power > 0 ? formatTime(deep_scan_eta, 'short') : '∞';
  const scan_available = !point_scan_complete || !deep_scan_complete;
  return (
    <Stack vertical fill>
      <Stack.Item grow>
        <Section
          fill
          title="现场数据"
          buttons={
            <Button
              content="返回"
              onClick={() => act('select_site', { site_ref: null })}
            />
          }
        >
          <LabeledList>
            <LabeledList.Item label="名称">{site.name}</LabeledList.Item>
            <LabeledList.Item label="描述">
              {site.revealed ? site.description : '无数据'}
            </LabeledList.Item>
            <LabeledList.Item label="距离">{site.distance}</LabeledList.Item>
            <LabeledList.Divider />
            <LabeledList.Item label="光谱数据" />
            <LabeledList.Divider />
            {Object.keys(site.band_info).map((band) => (
              <LabeledList.Item key={band} label={band}>
                {site.band_info[band]}
              </LabeledList.Item>
            ))}
          </LabeledList>
        </Section>
      </Stack.Item>
      {scan_available && (
        <Stack.Item>
          <Section fill title="扫描">
            {!point_scan_complete && (
              <Section title="点扫描">
                <BlockQuote>
                  点扫描对站点进行基本扫描，显示其一般特征.
                </BlockQuote>
                <Box>
                  <Button
                    content="扫描"
                    disabled={scan_power <= 0}
                    onClick={() => act('start_point_scan')}
                  />
                  <Box inline pl={3}>
                    预计时间: {point_cost}.
                  </Box>
                </Box>
              </Section>
            )}
            {!deep_scan_complete && (
              <Section title="深度扫描">
                <BlockQuote>深度扫描会进行全面的扫描，显示所有细节.</BlockQuote>
                <Box>
                  <Button
                    content="Scan"
                    disabled={scan_power <= 0}
                    onClick={() => act('start_deep_scan')}
                  />
                  <Box inline pl={3}>
                    预计时间: {deep_cost}.
                  </Box>
                </Box>
              </Section>
            )}
          </Section>
        </Stack.Item>
      )}
    </Stack>
  );
};

type ScanInProgressData = {
  scan_time: number;
  scan_power: number;
  scan_description: string;
};

const ScanInProgressModal = (props) => {
  const { act, data } = useBackend<ScanInProgressData>();
  const { scan_time, scan_power, scan_description } = data;

  return (
    <Modal ml={1}>
      <NoticeBox>扫描进行中!</NoticeBox>
      <Box color="danger" />
      <LabeledList>
        <LabeledList.Item label="扫描结论">{scan_description}</LabeledList.Item>
        <LabeledList.Item label="时间剩余">
          {formatTime(scan_time)}
        </LabeledList.Item>
        <LabeledList.Item label="扫描阵列功率">{scan_power}</LabeledList.Item>
        <LabeledList.Item label="紧急停止">
          <Button.Confirm
            content="停止扫描"
            color="red"
            icon="times"
            onClick={() => act('stop_scan')}
          />
        </LabeledList.Item>
      </LabeledList>
    </Modal>
  );
};

type ExoscannerConsoleData = {
  scan_in_progress: boolean;
  scan_power: number;
  possible_sites: Array<SiteData>;
  wide_scan_eta: number;
  selected_site: string;
  failed: boolean;
  scan_conditions: Array<string>;
};

export const ExoscannerConsole = (props) => {
  const { act, data } = useBackend<ExoscannerConsoleData>();
  const {
    scan_in_progress,
    scan_power,
    possible_sites = [],
    wide_scan_eta,
    selected_site,
    failed,
    scan_conditions = [],
  } = data;

  const can_start_wide_scan = scan_power > 0;

  return (
    <Window width={550} height={600}>
      {!!scan_in_progress && <ScanInProgressModal />}
      {!!failed && <ScanFailedModal />}
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Section fill title="可用阵列功率">
              <Stack>
                <Stack.Item grow>
                  {(scan_power > 0 && (
                    <>
                      <Box pr={1} inline fontSize={2}>
                        {scan_power}
                      </Box>
                      <Icon name="satellite-dish" size={3} />
                    </>
                  )) ||
                    '未检测到正确配置的扫描阵列.'}
                </Stack.Item>
              </Stack>
              <Section title="特殊扫描条件">
                {scan_conditions &&
                  scan_conditions.map((condition) => (
                    <NoticeBox key={condition}>{condition}</NoticeBox>
                  ))}
              </Section>
            </Section>
          </Stack.Item>
          {!!selected_site && (
            <Stack.Item grow>
              <ScanSelectionSection site_ref={selected_site} />
            </Stack.Item>
          )}
          {!selected_site && (
            <>
              <Stack.Item>
                <Section
                  buttons={
                    <Button
                      icon="search"
                      disabled={!can_start_wide_scan}
                      onClick={() => act('start_wide_scan')}
                    >
                      扫描
                    </Button>
                  }
                  fill
                  title="配置广谱扫描"
                >
                  <Stack>
                    <Stack.Item>
                      <BlockQuote>
                        广谱扫描，寻找任何与已知起始图像不匹配的东西.
                      </BlockQuote>
                    </Stack.Item>
                    <Stack.Item>
                      Cost estimate:{' '}
                      {scan_power > 0
                        ? formatTime(wide_scan_eta, 'short')
                        : '∞ 分钟'}
                    </Stack.Item>
                  </Stack>
                </Section>
              </Stack.Item>
              <Stack.Item grow>
                <Section
                  fill
                  title="配置目标扫描"
                  scrollable
                  buttons={
                    <Button
                      content="浏览实验"
                      onClick={() => act('open_experiments')}
                      icon="tasks"
                    />
                  }
                >
                  <Stack vertical>
                    {possible_sites.map((site) => (
                      <Stack.Item key={site.ref}>
                        <Button
                          content={site.name}
                          onClick={() =>
                            act('select_site', { site_ref: site.ref })
                          }
                        />
                      </Stack.Item>
                    ))}
                  </Stack>
                </Section>
              </Stack.Item>
            </>
          )}
        </Stack>
      </Window.Content>
    </Window>
  );
};
