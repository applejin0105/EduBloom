CREATE TABLE WrongWords (
  WordID INTEGER PRIMARY KEY
);

CREATE TABLE Log (
  LogDate      DATETIME PRIMARY KEY,
  TotalCount   INTEGER,
  CorrectCount INTEGER,
  Hours        INTEGER,
  Minutes      INTEGER
);

CREATE TABLE DAILY_WORDS (
  date    TEXT PRIMARY KEY,
  word_id INTEGER NOT NULL
);

CREATE TABLE WORDS (
    id INTEGER NOT NULL PRIMARY KEY,
    word VARCHAR(255) NOT NULL,
    part_of_speech VARCHAR(255) NOT NULL,
    meaning_korean VARCHAR(255) NOT NULL,
    example VARCHAR(255) NOT NULL,
    example_korean VARCHAR(255)
);

INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (1, 'agreement', 'noun', '계약', 'The two companies reached an agreement.', '두 회사는 계약에 도달했다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (2, 'policy', 'noun', '정책', 'The new company policy is effective immediately.', '새 회사 정책은 즉시 발효된다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (3, 'schedule', 'noun', '일정', 'My schedule is packed with meetings.', '내 일정은 회의로 가득하다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (4, 'employee', 'noun', '직원', 'The employee received a promotion.', '그 직원은 승진을 받았다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (5, 'equipment', 'noun', '장비', 'All equipment must be checked regularly.', '모든 장비는 정기적으로 점검되어야 한다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (6, 'investment', 'noun', '투자', 'The investment turned out to be profitable.', '그 투자는 수익성 있는 것으로 판명되었다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (7, 'management', 'noun', '경영', 'Management approved the proposal.', '경영진은 제안을 승인했다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (8, 'client', 'noun', '고객', 'We always prioritize client satisfaction.', '우리는 항상 고객 만족을 우선시한다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (9, 'conference', 'noun', '회의', 'The annual conference will be held in Seoul.', '연례 회의는 서울에서 개최된다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (10, 'advertisement', 'noun', '광고', 'The advertisement was very effective.', '그 광고는 매우 효과적이었다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (11, 'profit', 'noun', '이익', 'The company reported a high profit.', '회사는 높은 수익을 보고했다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (12, 'deadline', 'noun', '마감일', 'The deadline is next Monday.', '마감일은 다음 주 월요일이다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (13, 'account', 'noun', '계좌', 'He opened a new bank account.', '그는 새 은행 계좌를 개설했다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (14, 'benefit', 'noun', '혜택', 'Employees receive full benefits.', '직원들은 전면적인 복지 혜택을 받는다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (15, 'campaign', 'noun', '캠페인', 'The marketing campaign was successful.', '마케팅 캠페인은 성공적이었다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (16, 'contract', 'noun', '계약서', 'He signed a one-year contract.', '그는 1년 계약서에 서명했다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (17, 'department', 'noun', '부서', 'She works in the sales department.', '그녀는 영업 부서에서 일한다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (18, 'market', 'noun', '시장', 'The market is growing rapidly.', '시장은 빠르게 성장하고 있다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (19, 'offer', 'noun', '제안', 'They made a generous offer.', '그들은 후한 제안을 했다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (20, 'order', 'noun', '주문', 'I placed an order for new supplies.', '나는 새 비품을 주문했다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (21, 'payment', 'noun', '지불', 'Payment is due upon delivery.', '지불은 배송 시 이루어져야 한다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (22, 'request', 'noun', '요청', 'We received a request for more information.', '우리는 더 많은 정보 요청을 받았다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (23, 'increase', 'verb', '증가하다', 'Sales have increased significantly this year.', '올해 매출이 크게 증가했다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (24, 'reduce', 'verb', '줄이다', 'The company reduced expenses by 10%.', '회사는 비용을 10% 절감했다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (25, 'require', 'verb', '요구하다', 'This job requires computer skills.', '이 일은 컴퓨터 기술을 요구한다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (26, 'attend', 'verb', '참석하다', 'I will attend the seminar tomorrow.', '나는 내일 세미나에 참석할 것이다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (27, 'deliver', 'verb', '배달하다', 'They deliver the packages on time.', '그들은 소포를 제시간에 배달한다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (28, 'confirm', 'verb', '확인하다', 'Please confirm your reservation.', '예약을 확인해 주세요.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (29, 'apply', 'verb', '지원하다', 'I applied for the marketing position.', '나는 마케팅 직무에 지원했다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (30, 'approve', 'verb', '승인하다', 'The manager approved the budget.', '매니저는 예산을 승인했다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (31, 'notify', 'verb', '알리다', 'You will be notified of any changes.', '변경 사항이 있을 경우 알려드릴 것입니다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (32, 'submit', 'verb', '제출하다', 'Please submit your report by Friday.', '금요일까지 보고서를 제출해 주세요.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (33, 'hire', 'verb', '고용하다', 'We plan to hire more staff.', '우리는 더 많은 직원을 고용할 계획이다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (34, 'pay', 'verb', '지불하다', 'You must pay the fee in advance.', '수수료는 사전에 지불해야 한다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (35, 'cancel', 'verb', '취소하다', 'She canceled her subscription.', '그녀는 구독을 취소했다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (36, 'update', 'verb', '업데이트하다', 'Please update your contact info.', '연락처 정보를 업데이트해 주세요.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (37, 'develop', 'verb', '개발하다', 'They developed a new app.', '그들은 새로운 앱을 개발했다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (38, 'schedule', 'verb', '일정을 잡다', 'We scheduled a meeting.', '우리는 회의 일정을 잡았다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (39, 'expect', 'verb', '기대하다', 'We expect high attendance.', '우리는 높은 참석률을 기대한다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (40, 'improve', 'verb', '개선하다', 'We improved our service.', '우리는 서비스를 개선했다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (41, 'operate', 'verb', '운영하다', 'The machine operates smoothly.', '그 기계는 원활하게 작동한다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (42, 'sign', 'verb', '서명하다', 'Please sign at the bottom.', '아래에 서명해 주세요.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (43, 'train', 'verb', '훈련시키다', 'We train all new employees.', '우리는 모든 신입 직원을 교육한다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (44, 'win', 'verb', '이기다', 'Our team won the contract.', '우리 팀이 계약을 따냈다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (45, 'available', 'adjective', '이용 가능한', 'The product is available online.', '그 제품은 온라인에서 구입할 수 있다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (46, 'competitive', 'adjective', '경쟁력 있는', 'Our prices are very competitive.', '우리 가격은 매우 경쟁력이 있다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (47, 'qualified', 'adjective', '자격 있는', 'She is a qualified candidate.', '그녀는 자격을 갖춘 후보자이다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (48, 'financial', 'adjective', '재정적인', 'We need a financial advisor.', '우리는 재정 고문이 필요하다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (49, 'experienced', 'adjective', '경험 있는', 'We prefer experienced applicants.', '우리는 경험 있는 지원자를 선호한다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (50, 'efficient', 'adjective', '효율적인', 'The new system is more efficient.', '새 시스템은 더 효율적이다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (51, 'reliable', 'adjective', '신뢰할 수 있는', 'He is a reliable employee.', '그는 신뢰할 수 있는 직원이다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (52, 'suitable', 'adjective', '적합한', 'This job is suitable for beginners.', '이 일은 초보자에게 적합하다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (53, 'responsible', 'adjective', '책임 있는', 'She is responsible for the project.', '그녀는 그 프로젝트에 책임이 있다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (54, 'necessary', 'adjective', '필수적인', 'It is necessary to attend the meeting.', '회의에 참석하는 것이 필수적이다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (55, 'annual', 'adjective', '연간의', 'We hold an annual meeting.', '우리는 연례 회의를 개최한다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (56, 'basic', 'adjective', '기본적인', 'He needs basic training.', '그는 기본적인 훈련이 필요하다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (57, 'current', 'adjective', '현재의', 'Our current project is confidential.', '우리의 현재 프로젝트는 기밀이다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (58, 'frequent', 'adjective', '빈번한', 'Frequent updates are required.', '자주 업데이트가 필요하다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (59, 'important', 'adjective', '중요한', 'This is an important decision.', '이것은 중요한 결정이다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (60, 'limited', 'adjective', '제한된', 'This is a limited-time offer.', '이것은 한정된 시간의 제안이다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (61, 'mandatory', 'adjective', '의무적인', 'Attendance is mandatory.', '출석은 의무이다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (62, 'original', 'adjective', '원래의', 'We kept the original plan.', '우리는 원래의 계획을 유지했다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (63, 'popular', 'adjective', '인기 있는', 'This product is popular.', '이 제품은 인기가 있다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (64, 'specific', 'adjective', '구체적인', 'Please provide specific examples.', '구체적인 예를 제공해 주세요.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (65, 'temporary', 'adjective', '임시의', 'He has a temporary job.', '그는 임시직을 가지고 있다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (66, 'valuable', 'adjective', '가치 있는', 'Your feedback is valuable.', '당신의 피드백은 소중하다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (67, 'quickly', 'adverb', '빠르게', 'The issue was resolved quickly.', '문제는 빠르게 해결되었다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (68, 'recently', 'adverb', '최근에', 'I recently changed my job.', '나는 최근에 직장을 바꿨다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (69, 'usually', 'adverb', '보통', 'I usually take the bus.', '나는 보통 버스를 탄다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (70, 'often', 'adverb', '자주', 'He often works overtime.', '그는 자주 야근을 한다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (71, 'carefully', 'adverb', '조심스럽게', 'Please read the instructions carefully.', '설명서를 조심스럽게 읽어 주세요.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (72, 'clearly', 'adverb', '명확하게', 'She explained the rules clearly.', '그녀는 규칙을 명확하게 설명했다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (73, 'directly', 'adverb', '직접적으로', 'You can contact me directly.', '당신은 나에게 직접 연락할 수 있다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (74, 'easily', 'adverb', '쉽게', 'This app can be used easily.', '이 앱은 쉽게 사용할 수 있다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (75, 'immediately', 'adverb', '즉시', 'We need to act immediately.', '우리는 즉시 행동해야 한다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (76, 'simply', 'adverb', '간단히', 'You can simply upload the file.', '파일을 간단히 업로드할 수 있다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (77, 'barely', 'adverb', '간신히', 'He barely met the deadline.', '그는 간신히 마감일을 맞췄다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (78, 'constantly', 'adverb', '끊임없이', 'She constantly checks her email.', '그녀는 이메일을 끊임없이 확인한다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (79, 'daily', 'adverb', '매일', 'We report sales figures daily.', '우리는 매일 판매 수치를 보고한다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (80, 'eventually', 'adverb', '결국', 'He eventually agreed.', '그는 결국 동의했다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (81, 'highly', 'adverb', '매우', 'She is highly skilled.', '그녀는 매우 숙련되어 있다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (82, 'later', 'adverb', '나중에', 'I will call you later.', '내가 나중에 전화할게요.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (83, 'nearly', 'adverb', '거의', 'The project is nearly complete.', '그 프로젝트는 거의 완료되었다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (84, 'officially', 'adverb', '공식적으로', 'The merger was officially announced.', '합병은 공식적으로 발표되었다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (85, 'previously', 'adverb', '이전에', 'I had previously worked there.', '나는 예전에 거기서 일했었다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (86, 'rarely', 'adverb', '드물게', 'He rarely takes time off.', '그는 드물게 휴가를 간다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (87, 'soon', 'adverb', '곧', 'We will begin soon.', '우리는 곧 시작할 것이다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (88, 'together', 'adverb', '함께', 'We worked together on the task.', '우리는 그 일을 함께 했다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (89, 'he', 'pronoun', '그', 'He works in the IT department.', '그는 IT 부서에서 일한다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (90, 'she', 'pronoun', '그녀', 'She is on vacation.', '그녀는 휴가 중이다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (91, 'they', 'pronoun', '그들', 'They will join us for dinner.', '그들은 저녁 식사에 우리와 함께할 것이다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (92, 'we', 'pronoun', '우리', 'We should review the report.', '우리는 보고서를 검토해야 한다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (93, 'it', 'pronoun', '그것', 'It was a successful campaign.', '그것은 성공적인 캠페인이었다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (94, 'you', 'pronoun', '너', 'You are required to attend.', '당신은 참석해야 한다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (95, 'I', 'pronoun', '나', 'I sent the email yesterday.', '나는 어제 이메일을 보냈다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (96, 'me', 'pronoun', '나를', 'Please give me a call.', '나에게 전화해 주세요.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (97, 'them', 'pronoun', '그들을', 'I met them at the meeting.', '나는 회의에서 그들을 만났다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (98, 'us', 'pronoun', '우리를', 'Join us for the workshop.', '워크숍에 참여해 주세요.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (99, 'him', 'pronoun', '그를', 'I spoke to him yesterday.', '나는 어제 그와 이야기했다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (100, 'her', 'pronoun', '그녀를', 'We invited her to the event.', '우리는 그녀를 행사에 초대했다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (101, 'ours', 'pronoun', '우리의 것', 'This office is ours.', '이 사무실은 우리의 것이다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (102, 'theirs', 'pronoun', '그들의 것', 'That idea was theirs.', '그 아이디어는 그들의 것이었다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (103, 'mine', 'pronoun', '내 것', 'The laptop is mine.', '그 노트북은 내 것이다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (104, 'yourself', 'pronoun', '너 자신', 'Help yourself.', '스스로 가져가세요.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (105, 'ourselves', 'pronoun', '우리 자신', 'We prepared ourselves.', '우리는 우리 자신을 준비했다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (106, 'yours', 'pronoun', '너의 것', 'The seat is yours.', '그 자리는 너의 것이다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (107, 'hers', 'pronoun', '그녀의 것', 'The bag is hers.', '그 가방은 그녀의 것이다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (108, 'itself', 'pronoun', '그 자체', 'The idea itself is flawed.', '그 아이디어 자체가 잘못되었다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (109, 'themselves', 'pronoun', '그들 자신', 'They introduced themselves.', '그들은 스스로를 소개했다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (110, 'each other', 'pronoun', '서로', 'They respect each other.', '그들은 서로를 존중한다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (111, 'in', 'preposition', '~안에', 'She is in the office.', '그녀는 사무실 안에 있다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (112, 'on', 'preposition', '~위에', 'The report is on the desk.', '보고서는 책상 위에 있다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (113, 'at', 'preposition', '~에', 'We will meet at 3 p.m.', '우리는 오후 3시에 만날 것이다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (114, 'by', 'preposition', '~옆에, ~까지', 'Please submit it by Friday.', '금요일까지 제출해 주세요.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (115, 'with', 'preposition', '~와 함께', 'I came with my manager.', '나는 매니저와 함께 왔다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (116, 'about', 'preposition', '~에 대해', 'This book is about marketing.', '이 책은 마케팅에 관한 것이다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (117, 'for', 'preposition', '~을 위해', 'This is for new employees.', '이것은 신입 사원을 위한 것이다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (118, 'from', 'preposition', '~로부터', 'He is from the HR department.', '그는 인사 부서 소속이다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (119, 'to', 'preposition', '~에게, ~으로', 'Send the file to the client.', '파일을 고객에게 보내세요.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (120, 'under', 'preposition', '~아래에', 'The files are under the table.', '파일은 책상 아래에 있다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (121, 'across', 'preposition', '~건너', 'The bank is across the street.', '은행은 길 건너편에 있다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (122, 'after', 'preposition', '~후에', 'We will meet after lunch.', '우리는 점심 이후에 만날 것이다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (123, 'before', 'preposition', '~전에', 'Please arrive before 10 a.m.', '오전 10시 전에 도착해 주세요.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (124, 'during', 'preposition', '~동안', 'He was absent during the meeting.', '그는 회의 중에 자리를 비웠다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (125, 'inside', 'preposition', '~안에', 'The files are inside the drawer.', '서랍 안에 파일이 있다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (126, 'outside', 'preposition', '~밖에', 'Let’s wait outside the office.', '사무실 밖에서 기다리자.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (127, 'through', 'preposition', '~을 통해', 'He got the job through a friend.', '그는 친구를 통해 그 직업을 얻었다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (128, 'without', 'preposition', '~없이', 'Do not leave without permission.', '허락 없이 떠나지 마세요.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (129, 'near', 'preposition', '~근처에', 'There is a café near the station.', '역 근처에 카페가 있다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (130, 'along', 'preposition', '~을 따라', 'We walked along the river.', '우리는 강을 따라 걸었다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (131, 'onto', 'preposition', '~위로', 'Place the box onto the shelf.', '상자를 선반 위에 올려 놓으세요.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (132, 'into', 'preposition', '~안으로', 'He went into the room.', '그는 방으로 들어갔다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (133, 'and', 'conjunction', '~그리고', 'I bought a pen and a notebook.', '나는 펜과 공책을 샀다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (134, 'but', 'conjunction', '~하지만', 'I want to go, but I’m busy.', '가고 싶지만 바쁘다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (135, 'or', 'conjunction', '~또는', 'You can email or call me.', '이메일이나 전화 주세요.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (136, 'so', 'conjunction', '~그래서', 'It was late, so I went home.', '늦었기 때문에 집에 갔다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (137, 'because', 'conjunction', '~때문에', 'I’m late because of traffic.', '교통 체증 때문에 늦었다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (138, 'although', 'conjunction', '~비록 ~일지라도', 'Although it was raining, we played.', '비가 왔지만 우리는 놀았다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (139, 'while', 'conjunction', '~하는 동안', 'She was working while I was away.', '내가 없는 동안 그녀는 일했다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (140, 'since', 'conjunction', '~이래로', 'We have grown since last year.', '작년 이후 우리는 성장했다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (141, 'if', 'conjunction', '~한다면', 'If it rains, the event is canceled.', '비가 오면 행사는 취소된다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (142, 'unless', 'conjunction', '~하지 않으면', 'You won’t pass unless you study.', '공부하지 않으면 합격할 수 없다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (143, 'though', 'conjunction', '~이지만', 'Though tired, he worked late.', '피곤했지만 그는 늦게까지 일했다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (144, 'as', 'conjunction', '~처럼', 'Do as I say.', '내 말대로 해.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (145, 'than', 'conjunction', '~보다', 'She is taller than me.', '그녀는 나보다 키가 크다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (146, 'whether', 'conjunction', '~인지 아닌지', 'I don’t know whether he will come.', '그가 올지 안 올지 모르겠다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (147, 'because of', 'conjunction', '~때문에', 'The flight was delayed because of fog.', '안개 때문에 비행이 지연되었다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (148, 'even if', 'conjunction', '~일지라도', 'I’ll go even if it rains.', '비가 와도 나는 갈 것이다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (149, 'as long as', 'conjunction', '~하는 한', 'You can stay as long as you like.', '네가 원하는 만큼 머물러도 돼.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (150, 'as soon as', 'conjunction', '~하자마자', 'Call me as soon as you arrive.', '도착하자마자 전화해 주세요.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (151, 'in case', 'conjunction', '~하는 경우에 대비하여', 'Take an umbrella in case it rains.', '비가 올 경우에 대비해 우산을 챙기세요.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (152, 'now that', 'conjunction', '~이므로', 'Now that he’s here, we can start.', '그가 왔으니 이제 시작할 수 있다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (153, 'so that', 'conjunction', '~하기 위해서', 'We left early so that we could be on time.', '제시간에 도착하기 위해 우리는 일찍 출발했다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (154, 'in order that', 'conjunction', '~하기 위하여', 'He studies hard in order that he may pass.', '그는 시험에 합격하기 위해 열심히 공부한다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (155, 'wow', 'interjection', '와!', 'Wow, that’s amazing!', '와, 정말 놀라워!');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (156, 'oh', 'interjection', '오!', 'Oh, I didn’t know that.', '오, 그건 몰랐어.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (157, 'hey', 'interjection', '이봐!', 'Hey, what are you doing?', '이봐, 뭐 하고 있어?');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (158, 'oops', 'interjection', '이런!', 'Oops, I dropped it.', '이런, 떨어뜨렸어.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (159, 'hurray', 'interjection', '만세!', 'Hurray! We won the game.', '만세! 우리가 경기를 이겼어.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (160, 'ugh', 'interjection', '윽!', 'Ugh, this is so frustrating.', '윽, 정말 짜증난다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (161, 'ouch', 'interjection', '아야!', 'Ouch, that hurt!', '아야, 아팠어!');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (162, 'bravo', 'interjection', '브라보!', 'Bravo! Well done.', '브라보! 잘했어.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (163, 'alas', 'interjection', '아아', 'Alas, we lost the match.', '아아, 우리는 경기를 졌어.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (164, 'aha', 'interjection', '아하!', 'Aha, I see what you mean.', '아하, 무슨 말인지 알겠다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (165, 'congrats', 'interjection', '축하해!', 'Congrats on your promotion!', '승진 축하해!');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (166, 'phew', 'interjection', '휴!', 'Phew, that was close!', '휴, 정말 아슬아슬했어!');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (167, 'yay', 'interjection', '야호!', 'Yay! We made it!', '야호! 우리가 해냈어!');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (168, 'nah', 'interjection', '아니야', 'Nah, I’m good.', '아냐, 난 괜찮아.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (169, 'hmm', 'interjection', '흠', 'Hmm, I’m not sure.', '흠, 잘 모르겠어.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (170, 'shh', 'interjection', '쉿!', 'Shh! Be quiet.', '쉿! 조용히 해.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (171, 'uh-oh', 'interjection', '이런!', 'Uh-oh, we’re in trouble.', '이런, 큰일 났다.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (172, 'yikes', 'interjection', '헉!', 'Yikes, that was scary.', '헉, 무서웠어.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (173, 'ahem', 'interjection', '에헴', 'Ahem, may I speak?', '에헴, 말씀 좀 드릴게요.');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (174, 'whoa', 'interjection', '와우!', 'Whoa, slow down!', '우와, 천천히 해!');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (175, 'eek', 'interjection', '으악!', 'Eek! A mouse!', '으악! 쥐다!');
INSERT INTO WORDS (id, word, part_of_speech, meaning_korean, example, example_korean) VALUES (176, 'tsk', 'interjection', '쯧쯧', 'Tsk, that’s unfortunate.', '쯧쯧, 그거 안됐네.');
