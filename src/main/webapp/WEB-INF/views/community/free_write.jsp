<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<jsp:include page="/common/head.jsp"/>
    <script src="/resources/assets/js/summemote/summernote-lite.js"></script>
	<script src="/resources/assets/js/summemote/lang/summernote-ko-KR.js"></script>
	<link rel="stylesheet" href="/resources/assets/css/summemote/summernote-lite.css">  guide_board
	<link rel="stylesheet" type="text/css" href="https://nstatic.dcinside.com/dc/w/css/common.css?v=2004211415"/>
	<link rel="stylesheet" type="text/css" href="https://nstatic.dcinside.com/dc/w/css/contents.css?2007011213"/>
	<link rel="stylesheet" type="text/css" href="https://nstatic.dcinside.com/dc/w/css/popup.css?ver=200327"/>
	<link rel="stylesheet" type="text/css" href="//nstatic.dcinside.com/dc/w/css/editor_20141223.css?v=2"/>
	<link href="https://fonts.googleapis.com/css2?family=Hi+Melody&family=Jua&display=swap" rel="stylesheet">
</head>
<body>
<jsp:include page="/common/header.jsp"/>
<section style="padding-bottom: 300px" id ="pysSection">


<div class="writeall">
<div class="container" style="width: 100%">
<div class="game-info">
	<div class="game-info_background">
		<div class="game-content">
			<img src="https://talk.op.gg/images/game/icon-community-lol.png"
				alt="" class="game-info__icon">
			<h1 class="my-4">자유게시판</h1>
		</div>
	</div>
</div>
</div>
<div class="container" id="container_write">
	<div class="row">
<div class="col-lg-3" id="sidemenu">
	<div id="rdiv">
		<div style="text-align: right;">
			<div class="card" style="text-align: center; font-size:large ; border: 2px solid #000000; border-width: 2px 0px 2px 0px;">
				<c:choose>
					<c:when test="${sessionScope.user == null }">아이디<br>
							<input type="text" class="form-control" id="userId">
							<br>비밀번호<br>
							<input type="password" class="form-control" id="userPwd">
							<br>
							<div>
								<button class="btn btn-outline-success" onclick="login()">로그인</button>
							<a href="/views/user/join"><button
									class="btn btn-outline-success">회원가입</button></a>
						</div>
						<div id="check_login"></div>
					</c:when>
					<c:when test="${sessionScope.user != null }">	
						<div style="text-align: left;">
							<div style="float: left;">
								<div  style="min-width:240px; margin-top: 10px;">
									<img src="${sessionScope.user.userIcon}"
										style="height: 100px; border-radius: 70%;">									
									<div style="width: 130px; float: right; position: relative; margin-top: 15px; ">
										<h2 style="font-size:20px; font-weight: bolder;">${sessionScope.user.userNick}</h2>
									    <div id="userLev"></div>
								    </div>
								   	<div>					   
										<div id="userExt" style="margin-top:5px "></div>	
								    </div>								 	
								</div>
						    </div>
						</div>
						<div  style="margin-top: 10px;">		
							<a href="/views/user/lookUp"><button class="btn btn-outline-success">내가 쓴 글</button></a>
							<a href="/views/user/lookUp"><button class="btn btn-outline-success">내가 쓴 댓글</button></a>
							<div style="margin-top: 10px;">
								<button class="btn btn-outline-success" style=" border-color: #46cfa7; background-color: #16ae81; color: #fff; margin-bottom: 10px; " onclick="logOut()">로그아웃</button>
							</div>
						</div>
					</c:when>
				</c:choose>
			</div>
		</div>
	</div>
	<!-- 			<h1 class="my-4">자유게시판</h1>		 -->
	<div class="list-group" id="list-group">
		<a href="/views/community/freeBoard" class="list-group-item">자유게시판</a> 
		<a href="/views/community/guideBoard" class="list-group-item">공략게시판</a>
		<a href="javascript:void(0)" class="list-group-item">유머</a>
		<a href="javascript:void(0)" class="list-group-item">영상게시판</a>
		<a href="javascript:void(0)" class="list-group-item">팬 아트</a>
		<a href="javascript:void(0)" class="list-group-item">유저찾기</a>
	</div>
	<div class="newList">
		<table class="table table-hover" style="background-color:white; border: 2px solid #000000;
	border-width: 2px 0px 2px 0px;">
			<thead>
				<tr> 
					<th colspan="2">공략게시판 최신글</th>
				</tr>
			</thead>
			<tbody id="newTable"></tbody>		
		</table>
	</div>
</div>
<div class=container style="max-width:75%;position: relative; border: 1px solid #000000; border-width: 3px 0px 1px 0px; " >
<form id="formData" >
	<input type="hidden" id="userNum" name="userNum" value="${sessionScope.user.userNum}">
	<input type="hidden" id="userNick" name="userNick" value="${sessionScope.user.userNick}">
<div class="col-sm-10" style="margin-top: 15px;">
		<input class="form-control input-sm" type="text" id="freeTitle" name="freeTitle" 
		placeholder="제목을 입력해 주세요.">
		<hr>
	</div>
	
	<div class="col-sm-10">
		섬네일 : <input type="file" id="file" name="file"><br>
		<hr>
	</div>	
	  <textarea id="freeContent" name="freeContent"></textarea>
	
	<div align="right" style="margin:5px; ">
	<a href="/views/community/freeBoard"><button type="button" class="btn btn-outline-success">취소</button></a>
	<button type="button" onclick="goWrite()" class="btn btn-outline-success">작성하기</button>
	</div>
</form>	
</div>
</div>
</div>

</div>	
</section>
<script type="text/javascript">
window.addEventListener('load',loginCheck);
window.addEventListener('load',text);
window.addEventListener('load',selectNewList);
window.addEventListener('load',selectUserOne);
var userNum = ${(sessionScope.user eq null)?0:sessionScope.user.userNum};

function selectUserOne(){
	$.ajax({
		url : '/user/selectUserOne',
		data : {userNum : userNum},
		type :'POST',
		success : function(res){
			$('#userLev').html('<h2 style="font-size:15px; color:#16ae81;">레벨 '+res.userLevel+'</h2>');
			$('#userExt').html('<div class="progress"><div class="progress-bar progress-bar-striped bg-danger progress-bar-animated" role="progressbar" style="width: '+res.userExperience+'%" aria-valuenow="10" aria-valuemin="0" aria-valuemax="100"></div></div>')    
			if(res.userExperience < 80){
				$('#userExt').html('<div class="progress"><div class="progress-bar progress-bar-striped bg-warning progress-bar-animated" role="progressbar" style="width: '+res.userExperience+'%" aria-valuenow="10" aria-valuemin="0" aria-valuemax="100"></div></div>') 
			}if(res.userExperience  < 40){
				$('#userExt').html('<div class="progress"><div class="progress-bar progress-bar-striped  progress-bar-animated" role="progressbar" style="width: '+res.userExperience+'%" aria-valuenow="10" aria-valuemin="0" aria-valuemax="100"></div></div>') 
			}
		}
	})
}
function text() {
	//여기 아래 부분
	$('#freeContent').summernote({
		  height: 1000,                 // 에디터 높이
		  minHeight: null,             // 최소 높이
		  maxHeight: null,             // 최대 높이
		  focus: true,                  // 에디터 로딩후 포커스를 맞출지 여부
		  lang: "ko-KR",					// 한글 설정
		  placeholder: '최대 2048자까지 쓸 수 있습니다'	//placeholder 설정
	});
};


function loginCheck(){
	
	if($('#userNum').val() < 1){
		alert('로그인하세욧~');
		location.href = '/views/community/freeBoard';
	}
}



function goWrite(){
		if($('#userNum').val() < 1){
			alert('회원 가입 하고 작성해주세요');
			location.href = '/views/community/freeBoard';
			return
		}
	
		if($('#freeTitle').val().trim().length <=1 ){
			alert('제목을 입력해주세요');
			$('#freeTitle').focus();
			return
		}
		if($('#freeContent').val().trim().length <=1 ){
			alert('내용을 입력해주세요');
			$('#freeContent').focus();
			return
		}
	
	
	var formData = new FormData($('#formData')[0]);
		
	$.ajax({
		type : 'POST',
		url : '/community/write',
		enctype: 'multipart/form-data',
		data : formData,
		contentType : false,
		processData : false,
		success : function(res){
			if(res == 1 ){
				alert('입력성공');
				location.href='/views/community/freeBoard';
			}
		}
	})
}
function selectNewList(){
	$.ajax({
		url : '/community/selectNewList1',
		type : 'GET',
		success : function(res){
			var html ='';
			for(var idx in res){
			var col =res[idx];
			console.log(col.guideTitle);
			html += '<tr>';
			html += '<th>제목</th>';
			if(col.guideTitle.length>=11){
			html += '<td><a href="/views/community/guideView?guideNum=' + col.guideNum
			+ userNum+'">'+col.guideTitle.substring(0,7)+'...</a></td>';
			}else{
				html += '<td><a href="/views/community/guideView?guideNum=' + col.guideNum
				+ '">'+col.guideTitle+'</td>';	
			}			
			html += '</tr>';				
			}
			document.getElementById('newTable').innerHTML= html;
		}
		
		
	})
	
}
</script>
<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>
