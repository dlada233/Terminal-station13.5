import { sortBy } from 'common/collections';
import { capitalize } from 'common/string';
import { useState } from 'react';

import { useBackend, useLocalState } from '../backend';
import {
  Blink,
  Box,
  Button,
  Dimmer,
  Flex,
  Icon,
  Modal,
  Section,
  TextArea,
} from '../components';
import { Window } from '../layouts';
import { sanitizeText } from '../sanitize';
import { StatusDisplayControls } from './common/StatusDisplayControls';

const STATE_BUYING_SHUTTLE = 'buying_shuttle';
const STATE_CHANGING_STATUS = 'changing_status';
const STATE_MAIN = 'main';
const STATE_MESSAGES = 'messages';

// Used for whether or not you need to swipe to confirm an alert level change
const SWIPE_NEEDED = 'SWIPE_NEEDED';

const EMAG_SHUTTLE_NOTICE = '这艘飞船对船员极其危险，由辛迪加提供.';

const sortShuttles = (shuttles) =>
  sortBy(
    shuttles,
    (shuttle) => !shuttle.emagOnly,
    (shuttle) => shuttle.initial_cost,
  );

const AlertButton = (props) => {
  const { act, data } = useBackend();
  const { alertLevelTick, canSetAlertLevel } = data;
  const { alertLevel, setShowAlertLevelConfirm } = props;

  const thisIsCurrent = data.alertLevel === alertLevel;

  return (
    <Button
      icon="exclamation-triangle"
      color={thisIsCurrent && 'good'}
      content={capitalize(alertLevel)}
      onClick={() => {
        if (thisIsCurrent) {
          return;
        }

        if (canSetAlertLevel === SWIPE_NEEDED) {
          setShowAlertLevelConfirm([alertLevel, alertLevelTick]);
        } else {
          act('changeSecurityLevel', {
            newSecurityLevel: alertLevel,
          });
        }
      }}
    />
  );
};

const MessageModal = (props) => {
  const { data } = useBackend();
  const { maxMessageLength } = data;

  const [input, setInput] = useLocalState(props.label, '');

  const longEnough =
    props.minLength === undefined || input.length >= props.minLength;

  return (
    <Modal>
      <Flex direction="column">
        <Flex.Item fontSize="16px" maxWidth="90vw" mb={1}>
          {props.label}:
        </Flex.Item>

        <Flex.Item mr={2} mb={1}>
          <TextArea
            fluid
            height="20vh"
            width="80vw"
            backgroundColor="black"
            textColor="white"
            onInput={(_, value) => {
              setInput(value.substring(0, maxMessageLength));
            }}
            value={input}
          />
        </Flex.Item>

        <Flex.Item>
          <Button
            icon={props.icon}
            content={props.buttonText}
            color="good"
            disabled={!longEnough}
            tooltip={!longEnough ? '你需要一段更长的理由.' : ''}
            tooltipPosition="right"
            onClick={() => {
              if (longEnough) {
                setInput('');
                props.onSubmit(input);
              }
            }}
          />

          <Button
            icon="times"
            content="取消"
            color="bad"
            onClick={props.onBack}
          />
        </Flex.Item>

        {!!props.notice && (
          <Flex.Item maxWidth="90vw">{props.notice}</Flex.Item>
        )}
      </Flex>
    </Modal>
  );
};

const NoConnectionModal = () => {
  return (
    <Dimmer>
      <Flex direction="column" textAlign="center" width="300px">
        <Flex.Item>
          <Icon color="red" name="wifi" size={10} />

          <Blink>
            <div
              style={{
                background: '#db2828',
                bottom: '60%',
                left: '25%',
                height: '10px',
                position: 'relative',
                transform: 'rotate(45deg)',
                width: '150px',
              }}
            />
          </Blink>
        </Flex.Item>

        <Flex.Item fontSize="16px">无法建立与站点的联系.</Flex.Item>
      </Flex>
    </Dimmer>
  );
};

const PageBuyingShuttle = (props) => {
  const { act, data } = useBackend();

  return (
    <Box>
      <Section>
        <Button
          icon="chevron-left"
          content="返回"
          onClick={() => act('setState', { state: STATE_MAIN })}
        />
      </Section>

      <Section>
        预算: <b>{data.budget.toLocaleString()}</b>信用点
      </Section>

      {sortShuttles(data.shuttles).map((shuttle) => (
        <Section
          title={
            <span
              style={{
                display: 'inline-block',
                width: '70%',
              }}
            >
              {shuttle.name}
            </span>
          }
          key={shuttle.ref}
          buttons={
            <Button
              content={`${shuttle.creditCost.toLocaleString()}信用点`}
              color={shuttle.emagOnly ? 'red' : 'default'}
              disabled={data.budget < shuttle.creditCost}
              onClick={() =>
                act('purchaseShuttle', {
                  shuttle: shuttle.ref,
                })
              }
              tooltip={
                data.budget < shuttle.creditCost
                  ? `你还需要${shuttle.creditCost - data.budget}信用点.`
                  : shuttle.emagOnly
                    ? EMAG_SHUTTLE_NOTICE
                    : undefined
              }
              tooltipPosition="left"
            />
          }
        >
          <Box>{shuttle.description}</Box>
          <Box color="teal" fontSize="10px" italic>
            容纳限制: {shuttle.occupancy_limit}
          </Box>
          <Box color="violet" fontSize="10px" bold>
            {shuttle.prerequisites ? (
              <b>前提条件: {shuttle.prerequisites}</b>
            ) : null}
          </Box>
        </Section>
      ))}
    </Box>
  );
};

const PageChangingStatus = (props) => {
  const { act } = useBackend();

  return (
    <Box>
      <Section>
        <Button
          icon="chevron-left"
          content="返回"
          onClick={() => act('setState', { state: STATE_MAIN })}
        />
      </Section>

      <StatusDisplayControls />
    </Box>
  );
};

const PageMain = (props) => {
  const { act, data } = useBackend();
  const {
    alertLevel,
    alertLevelTick,
    aprilFools,
    callShuttleReasonMinLength,
    canBuyShuttles,
    canMakeAnnouncement,
    canMessageAssociates,
    canRecallShuttles,
    canRequestNuke,
    canSendToSectors,
    canSetAlertLevel,
    canToggleEmergencyAccess,
    canToggleEngineeringOverride, // SKYRAT EDIT - Engineering Override
    emagged,
    syndicate,
    emergencyAccess,
    engineeringOverride, // SKYRAT EDIT - Engineering Override
    importantActionReady,
    sectors,
    shuttleCalled,
    shuttleCalledPreviously,
    shuttleCanEvacOrFailReason,
    shuttleLastCalled,
    shuttleRecallable,
  } = data;

  const [callingShuttle, setCallingShuttle] = useState(false);
  const [messagingAssociates, setMessagingAssociates] = useState(false);
  const [messagingSector, setMessagingSector] = useState(null);
  const [requestingNukeCodes, setRequestingNukeCodes] = useState(false);

  const [
    [showAlertLevelConfirm, confirmingAlertLevelTick],
    setShowAlertLevelConfirm,
  ] = useState([null, null]);

  return (
    <Box>
      {!syndicate && (
        <Section title="应急撤离飞船">
          {(!!shuttleCalled && (
            <Button.Confirm
              icon="space-shuttle"
              content="召回撤离飞船"
              color="bad"
              disabled={!canRecallShuttles || !shuttleRecallable}
              tooltip={
                (canRecallShuttles &&
                  !shuttleRecallable &&
                  '现在召回撤离飞船已经太晚了.') ||
                '你无权召回撤离飞船.'
              }
              tooltipPosition="bottom-end"
              onClick={() => act('recallShuttle')}
            />
          )) || (
            <Button
              icon="space-shuttle"
              content="呼叫撤离飞船"
              disabled={shuttleCanEvacOrFailReason !== 1}
              tooltip={
                shuttleCanEvacOrFailReason !== 1
                  ? shuttleCanEvacOrFailReason
                  : undefined
              }
              tooltipPosition="bottom-end"
              onClick={() => setCallingShuttle(true)}
            />
          )}
          {!!shuttleCalledPreviously &&
            ((shuttleLastCalled && (
              <Box>
                最近的撤离飞船呼叫/召回被追踪到: <b>{shuttleLastCalled}</b>
              </Box>
            )) || <Box>无法追踪到最近的撤离飞船呼叫/召回信号.</Box>)}
        </Section>
      )}

      {!!canSetAlertLevel && (
        <Section title="警报等级">
          <Flex justify="space-between">
            <Flex.Item>
              <Box>
                当前处于<b>{capitalize(alertLevel)}</b>警报
              </Box>
            </Flex.Item>

            <Flex.Item>
              <AlertButton
                alertLevel="绿色"
                showAlertLevelConfirm={showAlertLevelConfirm}
                setShowAlertLevelConfirm={setShowAlertLevelConfirm}
              />

              <AlertButton
                alertLevel="蓝色"
                showAlertLevelConfirm={showAlertLevelConfirm}
                setShowAlertLevelConfirm={setShowAlertLevelConfirm}
              />

              <AlertButton
                // SKYRAT EDIT ADDTION BEGIN - ALERTS
                alertLevel="紫罗兰色"
                showAlertLevelConfirm={showAlertLevelConfirm}
                setShowAlertLevelConfirm={setShowAlertLevelConfirm}
              />

              <AlertButton
                alertLevel="橙色"
                showAlertLevelConfirm={showAlertLevelConfirm}
                setShowAlertLevelConfirm={setShowAlertLevelConfirm}
              />

              <AlertButton
                alertLevel="琥珀色"
                showAlertLevelConfirm={showAlertLevelConfirm}
                setShowAlertLevelConfirm={setShowAlertLevelConfirm}
                // SKYRAT EDIT END
              />
            </Flex.Item>
          </Flex>
        </Section>
      )}

      <Section title="功能">
        <Flex direction="column">
          {!!canMakeAnnouncement && (
            <Button
              icon="bullhorn"
              content="发布全站公告"
              onClick={() => act('makePriorityAnnouncement')}
            />
          )}
          {!!canToggleEmergencyAccess && (
            <Button.Confirm
              icon="id-card-o"
              content={`${emergencyAccess ? '关闭' : '开启'} 维护通道应急权限`}
              color={emergencyAccess ? 'bad' : undefined}
              onClick={() => act('toggleEmergencyAccess')}
            />
          )}

          {/* SKYRAT EDIT ADDITION START - Engineering Override */}
          {!!canToggleEngineeringOverride && (
            <Button.Confirm
              icon="wrench"
              content={`${engineeringOverride ? '关闭' : '开启'} 工程超驰权限`}
              color={engineeringOverride ? 'bad' : undefined}
              onClick={() => act('toggleEngOverride')}
            />
          )}
          {/* SKYRAT EDIT ADDITION END */}

          {!syndicate && (
            <Button
              icon="desktop"
              content="设定状态显示"
              onClick={() => act('setState', { state: STATE_CHANGING_STATUS })}
            />
          )}

          <Button
            icon="envelope-o"
            content="消息列表"
            onClick={() => act('setState', { state: STATE_MESSAGES })}
          />

          {canBuyShuttles !== 0 && (
            <Button
              icon="shopping-cart"
              content="购买撤离飞船"
              disabled={canBuyShuttles !== 1}
              // canBuyShuttles is a string detailing the fail reason
              // if one can be given
              tooltip={canBuyShuttles !== 1 ? canBuyShuttles : undefined}
              tooltipPosition="right"
              onClick={() => act('setState', { state: STATE_BUYING_SHUTTLE })}
            />
          )}

          {!!canMessageAssociates && (
            <Button
              icon="comment-o"
              content={`发送消息至 ${emagged ? '[UNKNOWN]' : 'CentCom'}`}
              disabled={!importantActionReady}
              onClick={() => setMessagingAssociates(true)}
            />
          )}

          {!!canRequestNuke && (
            <Button
              icon="radiation"
              content="请求核认证代码"
              disabled={!importantActionReady}
              onClick={() => setRequestingNukeCodes(true)}
            />
          )}

          {!!emagged && !syndicate && (
            <Button
              icon="undo"
              content="恢复备份路由数据"
              onClick={() => act('restoreBackupRoutingData')}
            />
          )}
          {
            // SKYRAT EDIT BEGIN
          }
          {!!canMakeAnnouncement && (
            <Button
              icon="bullhorn"
              content="拨打911: 司法援助响应"
              onClick={() => act('callThePolice')}
            />
          )}
          {!!canMakeAnnouncement && (
            <Button
              icon="bullhorn"
              content="拨打811: 大气工程响应"
              onClick={() => act('callTheCatmos')}
            />
          )}
          {!!canMakeAnnouncement && (
            <Button
              icon="bullhorn"
              content="拨打911: 医疗援助响应"
              onClick={() => act('callTheParameds')}
            />
          )}
          {!!emagged && (
            <Button
              icon="bullhorn"
              content="点一份Dogginos披萨"
              onClick={() => act('callThePizza')}
            />
          )}
          {
            // SKYRAT EDIT END
          }
        </Flex>
      </Section>

      {!!canMessageAssociates && messagingAssociates && (
        <MessageModal
          label={`量子传输信息至 ${emagged ? '[路径坐标异常]' : 'CentCom'}`}
          notice="请注意，信息传输成本十分昂贵，滥用将导致...结束. 此外，不保证有回复."
          icon="bullhorn"
          buttonText="Send"
          onBack={() => setMessagingAssociates(false)}
          onSubmit={(message) => {
            setMessagingAssociates(false);
            act('messageAssociates', {
              message,
            });
          }}
        />
      )}

      {!!canRequestNuke && requestingNukeCodes && (
        <MessageModal
          label="请求核弹自毁程序代码的理由"
          notice="在任何情况下都不能容忍滥用核自毁程序. 不保证有回复."
          icon="bomb"
          buttonText="请求代码"
          onBack={() => setRequestingNukeCodes(false)}
          onSubmit={(reason) => {
            setRequestingNukeCodes(false);
            act('requestNukeCodes', {
              reason,
            });
          }}
        />
      )}

      {!!callingShuttle && (
        <MessageModal
          label="紧急情况性质"
          icon="space-shuttle"
          buttonText="呼叫撤离飞船"
          minLength={callShuttleReasonMinLength}
          onBack={() => setCallingShuttle(false)}
          onSubmit={(reason) => {
            setCallingShuttle(false);
            act('callShuttle', {
              reason,
            });
          }}
        />
      )}

      {!!canSetAlertLevel &&
        showAlertLevelConfirm &&
        confirmingAlertLevelTick === alertLevelTick && (
          <Modal>
            <Flex direction="column" textAlign="center" width="300px">
              <Flex.Item fontSize="16px" mb={2}>
                刷动ID来确认更改
              </Flex.Item>

              <Flex.Item mr={2} mb={1}>
                <Button
                  icon="id-card-o"
                  content="刷动ID卡"
                  color="good"
                  fontSize="16px"
                  onClick={() =>
                    act('changeSecurityLevel', {
                      newSecurityLevel: showAlertLevelConfirm,
                    })
                  }
                />

                <Button
                  icon="times"
                  content="取消"
                  color="bad"
                  fontSize="16px"
                  onClick={() => setShowAlertLevelConfirm(false)}
                />
              </Flex.Item>
            </Flex>
          </Modal>
        )}

      {!!canSendToSectors && sectors.length > 0 && (
        <Section title="友方星区">
          <Flex direction="column">
            {sectors.map((sectorName) => (
              <Flex.Item key={sectorName}>
                <Button
                  content={`发送消息给 ${sectorName} 星区的空间站.`}
                  disabled={!importantActionReady}
                  onClick={() => setMessagingSector(sectorName)}
                />
              </Flex.Item>
            ))}

            {sectors.length > 2 && (
              <Flex.Item>
                <Button
                  content="给所有友方空间站发送消息."
                  disabled={!importantActionReady}
                  onClick={() => setMessagingSector('all')}
                />
              </Flex.Item>
            )}
          </Flex>
        </Section>
      )}

      {!!canSendToSectors && sectors.length > 0 && messagingSector && (
        <MessageModal
          label="给所有友方空间站发送消息"
          notice="请注意，这个传输过程非常昂贵，滥用将导致...结束."
          icon="bullhorn"
          buttonText="Send"
          onBack={() => setMessagingSector(null)}
          onSubmit={(message) => {
            act('sendToOtherSector', {
              destination: messagingSector,
              message,
            });

            setMessagingSector(null);
          }}
        />
      )}
    </Box>
  );
};

const PageMessages = (props) => {
  const { act, data } = useBackend();
  const messages = data.messages || [];

  const children = [];

  children.push(
    <Section>
      <Button
        icon="chevron-left"
        content="返回"
        onClick={() => act('setState', { state: STATE_MAIN })}
      />
    </Section>,
  );

  const messageElements = [];

  for (const [messageIndex, message] of Object.entries(messages)) {
    let answers = null;

    if (message.possibleAnswers.length > 0) {
      answers = (
        <Box mt={1}>
          {message.possibleAnswers.map((answer, answerIndex) => (
            <Button
              content={answer}
              color={message.answered === answerIndex + 1 ? 'good' : undefined}
              key={answerIndex}
              onClick={
                message.answered
                  ? undefined
                  : () =>
                      act('answerMessage', {
                        message: parseInt(messageIndex, 10) + 1,
                        answer: answerIndex + 1,
                      })
              }
            />
          ))}
        </Box>
      );
    }

    const textHtml = {
      __html: sanitizeText(message.content),
    };

    messageElements.push(
      <Section
        title={message.title}
        key={messageIndex}
        buttons={
          <Button.Confirm
            icon="trash"
            content="删除"
            color="red"
            onClick={() =>
              act('deleteMessage', {
                message: messageIndex + 1,
              })
            }
          />
        }
      >
        <Box dangerouslySetInnerHTML={textHtml} />

        {answers}
      </Section>,
    );
  }

  children.push(messageElements.reverse());

  return children;
};

export const CommunicationsConsole = (props) => {
  const { act, data } = useBackend();
  const {
    authenticated,
    authorizeName,
    canLogOut,
    emagged,
    hasConnection,
    page,
    canRequestSafeCode,
    safeCodeDeliveryWait,
    safeCodeDeliveryArea,
  } = data;

  return (
    <Window width={400} height={650} theme={emagged ? 'syndicate' : undefined}>
      <Window.Content scrollable>
        {!hasConnection && <NoConnectionModal />}

        {(canLogOut || !authenticated) && (
          <Section title="身份验证">
            <Button
              icon={authenticated ? 'sign-out-alt' : 'sign-in-alt'}
              content={
                authenticated
                  ? `注销${authorizeName ? ` (${authorizeName})` : ''}`
                  : '登录'
              }
              color={authenticated ? 'bad' : 'good'}
              onClick={() => act('toggleAuthentication')}
            />
          </Section>
        )}

        {(!!canRequestSafeCode && (
          <Section title="应急安全密码">
            <Button
              icon="key"
              content="请求安全密码"
              color="good"
              onClick={() => act('requestSafeCodes')}
            />
          </Section>
        )) ||
          (!!safeCodeDeliveryWait && (
            <Section title="应急安全密码送达">
              {`投放补给舱至${safeCodeDeliveryArea}在\
            ${Math.round(safeCodeDeliveryWait / 10)}秒内`}
            </Section>
          ))}

        {!!authenticated &&
          ((page === STATE_BUYING_SHUTTLE && <PageBuyingShuttle />) ||
            (page === STATE_CHANGING_STATUS && <PageChangingStatus />) ||
            (page === STATE_MAIN && <PageMain />) ||
            (page === STATE_MESSAGES && <PageMessages />) || (
              <Box>页面未实现: {page}</Box>
            ))}
      </Window.Content>
    </Window>
  );
};
