<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert</title>
<%@ include file="/common/head.jsp" %>
</head>
<style>
.services .icon-box {
    text-align: center;
    padding: 70px 20px 80px 20px;
    transition: all ease-in-out 0.3s;
    background: #000;
}
#spell img{
	width: 64px;
	margin: 10px 0 10px 0 ;
	 max-width: 100%; height: auto;  padding: 0px;
    opacity: 0.3;
    filter: alpha(opacity=40); 
}
#spell img:hover{
	width: 64px;
	margin: 10px 0 10px 0 ;
	 max-width: 100%; height: auto; border:2px solid #efff00c2; padding: 0px;
    opacity: 0.3;
    filter: alpha(opacity=40); 
}
.section-bg {
    background-color: #000000;
}

</style>
<body>

<%@ include file="/common/header.jsp" %>	

<main id="main">
    <!-- ======= Blog Section ======= -->
<section id="services" class="services section-bg" style="padding: 0 0 0 0; height: 100vh">

    <div class="container" data-aos="fade-up" >
    <div style="float: left">
      <div class="row">
	    <div style="width: 150px" align="center">
	     	<img src="http://ddragon.leagueoflegends.com/cdn/16.3.1/img/champion/${champion.championInfoId}.png" width="150px">
	     	<h3 style=" cursive;color: white; margin: 0">${champion.championInfoName}</h3>
	    </div>
	    <div  style="width: 200px">
	    </div>
	  </div>
        <div class="row" >
         <c:forEach begin="0" end="4" var="i" >
          <div class="align-items-stretch" data-aos="zoom-in" data-aos-delay="100" align="center" style="padding: 0px;" >
            <div class="icon-box iconbox-blue" style="padding: 0px;  width: 80px">
              <div class="icon${i}" id="spell">
              </div>
            </div>
          </div>
          </c:forEach>
          </div>
         </div>
             <div id='description' style="width: 40%;font-size: 15px;color:white; margin: 20px 0 0 200px; cursive; float: left;">
	     	 
	   		 </div>
        </div>

         
    </section><!-- End Services Section -->
</main>
<script>
function getDes(num){
		$('#Qdes').hide();
		$('#Wdes').hide();
		$('#Edes').hide();
		$('#Rdes').hide();
		$('#Pdes').hide();
		$('#imageQ').css('opacity','0.3');
		$('#imageW').css('opacity','0.3');
		$('#imageE').css('opacity','0.3');
		$('#imageR').css('opacity','0.3');
		$('#imageP').css('opacity','0.3');
		if(num===1){
			$('#Qdes').toggle();
			$('#imageQ').css('opacity','1');
		}
		if(num===2){
			$('#Wdes').toggle();
			$('#imageW').css('opacity','1');
		}
		if(num===3){
			$('#Edes').toggle();
			$('#imageE').css('opacity','1');
		}
		if(num===4){
			$('#Rdes').toggle();
			$('#imageR').css('opacity','1');
		}
		if(num===0){
			$('#Pdes').toggle();
			$('#imageP').css('opacity','1');
		}
}
function getSpell(spell){
	var cooldown=spell.championSpellCooldown; /* 재사용 */
	var cost=spell.championSpellCost; /* 비용 */
	var description=spell.championSpellDescription;/* 설명 */
	var imageId=spell.championSpellId;
	var name=spell.championSpellName; /* 이름 */
	var range=spell.championSpellRange; /* 범위 */
	var type=spell.championSpellType; /* 단축키  */  
	if(type=='Q'){
		var html ='';
		html +='<img id="imageQ" src="http://ddragon.leagueoflegends.com/cdn/16.3.1/img/spell/'+imageId+'.png" onmouseover="getDes(1)">'
		$('.icon1').html(html);
		html ='';
		html +='<div style="display:none" id="Qdes"><span style="color:yellow">'+name+'</span><br>';
		if(cooldown)
			html +='<span style="color: yellow;">재사용시간 : </span>'+cooldown+'<br>';
		if(cost)
			html +='<span style="color: yellow;">소모값 : </span>'+cost+'<br>';
		if(range)
			html +='<span style="color: yellow;">범위 : </span>'+range+'<br>';
		$('#description').append(html+description+'</div>');
		return;
	}
	if(type=='W'){
		var html ='';
		html +='<img id="imageW" src="http://ddragon.leagueoflegends.com/cdn/16.3.1/img/spell/'+imageId+'.png" onmouseover="getDes(2)">'
		$('.icon2').html(html);
		html ='';
		html +='<div style="display:none" id="Wdes"><span style="color:yellow">'+name+'</span><br>';
		if(cooldown)
			html +='<span colo style="color: yellow;"r>재사용시간 : </span>'+cooldown+'<br>';
		if(cost)
			html +='<span style="color: yellow;">소모값 : </span>'+cost+'<br>';
		if(range)
			html +='<span style="color: yellow;">범위 : </span>'+range+'<br>';
		$('#description').append(html+description+'</div>');
		return;
	}
	if(type=='E'){
		var html ='';
		html +='<img id="imageE" src="http://ddragon.leagueoflegends.com/cdn/16.3.1/img/spell/'+imageId+'.png" onmouseover="getDes(3)">'
		$('.icon3').html(html);
		html ='';
		html +='<div style="display:none" id="Edes"><span style="color:yellow">'+name+'</span><br>';
		if(cooldown)
			html +='<span style="color: yellow;">재사용시간 : </span>'+cooldown+'<br>';
		if(cost)
			html +='<span style="color: yellow;">소모값 : </span>'+cost+'<br>';
		if(range)
			html +='<span style="color: yellow;">범위 : </span>'+range+'<br>';
		$('#description').append(html+description+'</div>');
		return;
	}
	if(type=='R'){
		var html ='';
		html +='<img id="imageR" src="http://ddragon.leagueoflegends.com/cdn/16.3.1/img/spell/'+imageId+'.png" onmouseover="getDes(4)">'
		$('.icon4').html(html);
		html ='';
		html +='<div style="display:none" id="Rdes"><span style="color:yellow">'+name+'</span><br>';
		if(cooldown)
			html +='<span style="color: yellow;">재사용시간 : </span>'+cooldown+'<br>';
		if(cost)
			html +='<span style="color: yellow;">소모값 : </span>'+cost+'<br>';
		if(range)
			html +='<span style="color: yellow;">범위 : </span>'+range+'<br>';
		$('#description').append(html+description+'</div>');
		return;
	}
	if(type=='P'){
		var html ='';
		html +='<img id="imageP" src="http://ddragon.leagueoflegends.com/cdn/16.3.1/img/passive/'+imageId+'.png" onmouseover="getDes(0)">'
		$('.icon0').html(html);
		html ='';
		html +='<div style="display:none" id="Pdes"><span style="color:yellow">'+name+'</span><br>';
		$('#description').append(html+description+'</div>');
		$('#Pdes').css('display','block');
		$('#imageP').css('opacity','1');
		return;
	}
}
	$.ajax({
		url:'/spell',
		data:{championInfoId:'${champion.championInfoId}'},
		method:'POST', 
		success:function(res){
			for(var spell of res){
				getSpell(spell);
				
			}
		}
		
	})
</script>
<%@ include file="/common/footer.jsp" %>	
</body>
</html>