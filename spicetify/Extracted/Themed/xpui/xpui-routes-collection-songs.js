"use strict";(("undefined"!=typeof self?self:global).webpackChunkclient_web=("undefined"!=typeof self?self:global).webpackChunkclient_web||[]).push([[7553],{1550:(e,t,a)=>{a.r(t),a.d(t,{default:()=>oe});a(95101),a(32548);var l=a(50959),n=a(40587),o=a(5311),r=a(56057),s=a(31028),i=a(38762),c=a(98900),u=a(27293),d=a(1922),g=a(77671),m=a(41417),p=a(65885),f=a(56608),h=a(44903),y=a(35675),x=a(73737),j=a(68486),k=a(1526),C=a(11414),T=a(40021),D=a(98724);var F=a(8314),b=a(46227),I=a(42189),S=a(33299),P=a(45151),E=a(93549),w=a(82565),v=a(10862),A=a(10785),L=a(26265),R=a(46632),M=a(98330),N=a(60035),_=a(40085),Q=a(11527);const U=l.memo((({tracklistDomRef:e})=>{const{spec:t,logger:a}=(0,I.fU)(R.createDesktopSearchBarEventFactory,{}),n=(0,l.useCallback)((()=>{a.logInteraction(t.filterFieldFactory().keyStrokeFilter())}),[a,t]),o=(0,l.useCallback)((()=>{a.logInteraction(t.filterFieldFactory().hitClearFilter())}),[a,t]),r=(0,M.v)().filter((e=>h.P0.includes(e)));return(0,Q.jsxs)("div",{className:m.Z.searchBoxContainer,children:[(0,Q.jsx)(l.Suspense,{fallback:null,children:(0,Q.jsx)(N.K,{placeholder:c.ag.get("playlist.search_in_playlist"),clearOnEscapeInElementRef:e,onFilter:n,onClear:o})}),(0,Q.jsx)(_.l,{columns:r})]})}));var O=a(14996),B=a(5326),z=a(40189);const G="bKlB8pmFVoswJlZ_jhtL",K=l.memo((function({metadata:e,onClickTogglePlay:t,isPlaying:a,spec:n,logger:o,backgroundColor:r,canSort:s,canFilter:i}){const{uri:u,name:d,totalLength:g}=e,m=(0,l.useRef)(null),p=(0,l.useMemo)((()=>n.actionBarFactory()),[n]),f=(0,l.useMemo)((()=>p.shuffleButtonContainerFactory()),[p]),h=g>0,y=g>0,x=s&&i,j=(0,z.Q)(),k=(0,l.useCallback)(((e,t)=>{const a=p.downloadButtonFactory();t===A.mc.ADD?o.logInteraction(a.hitDownload({itemToDownload:u})):t===A.mc.REMOVE?o.logInteraction(a.hitRemoveDownload({itemToRemoveFromDownloads:u})):t===A.mc.NO_PERMISSION&&o.logInteraction(a.hitUiReveal())}),[p,o,u]),C=(0,O.j)();return(0,Q.jsx)(S.o,{backgroundColor:r,children:(0,Q.jsxs)(S.F,{children:[y?(0,Q.jsx)(w.$,{onClick:t,isPlaying:a,size:C,uri:u,ariaPauseLabel:c.ag.get("playlist.a11y.pause",d),ariaPlayLabel:c.ag.get("playlist.a11y.play",d)}):null,j&&(0,Q.jsx)(I.Nh,{spec:f,children:(0,Q.jsx)(B.K,{entityName:d,contextUri:u,activationPlacement:"bottomEnd",size:C})}),(0,Q.jsx)(P.o,{uri:u,canDownload:h,isFollowing:!0,onFollow:()=>{},size:C,onClick:k}),x?(0,Q.jsx)(I.Nh,{spec:p,children:(0,Q.jsx)(U,{tracklistDomRef:m})}):(0,Q.jsx)("div",{className:G,children:(0,Q.jsx)(E.F,{property:L.FM,renderNewExperience:()=>(0,Q.jsx)(v.A,{options:[],onSelect:()=>{},selected:null,enableViewModeMenu:!0})})})]})})}));var V=a(32147),H=a(7442),Z=a(6587),J=a(97138),W=a(12864),Y=a(39017),$=a(33329),q=a(2507),X=a(13978),ee=a(298),te=a(60810);const ae=[f.QD.INDEX,f.QD.TITLE_AND_ARTIST,f.QD.ALBUM,f.QD.ADDED_AT,f.QD.DURATION],le=({data:e,canFilter:t,canSort:a})=>{const{uri:n,name:i,totalLength:F}=e.metadata,S=(0,l.useRef)(null),P=(0,k.Y5)("#5038a0"),{filter:E}=(0,l.useContext)(p.fo),{sortState:w,setSortState:v}=(0,l.useContext)(h.Gb),{spec:A,logger:L}=(0,I.fU)(s.Q,{data:{uri:n}}),R=l.useMemo((()=>A.headerFactory()),[A]),M=l.useMemo((()=>A.tracklistFactory()),[A]);(0,l.useEffect)((()=>{null===w.column&&v({column:f.QD.ADDED_AT,order:f.kn.DESC})}),[w,v]);const N=(0,o.ur)(),_=(0,o.TH)(),U="POP"!==N?new URLSearchParams(_.search).get("uri"):null,{isPlaying:O,togglePlay:B,usePlayContextItem:z,isActive:G}=(0,b.n)(function(e,t,a){const l={uri:e};return(0,C.R4)(l,t),(0,T.IC)(l,(0,D.cj)(a)),l}(n,(0,V.w)(w),E),{featureIdentifier:"your_library",referrerIdentifier:"your_library"}),W=()=>{const e=(0,J.aK)({isPlaying:O,isActive:G,spec:A.actionBarFactory().playButtonFactory(),logger:L,uri:n});B({loggingParams:e})},[Y]=(0,Z.d4)(),{isCompactMode:$}=(0,j.mJ)(),q=(({isCompactMode:e=!1})=>{const t=[...ae];return e&&t.splice(t.indexOf(f.QD.TITLE_AND_ARTIST),1,f.QD.TITLE,f.QD.ARTIST),t})({isCompactMode:$});return(0,Q.jsx)(y.a,{columns:q,children:(0,Q.jsxs)("section",{role:"presentation",className:m.Z.playlist,"data-testid":"playlist-page",children:[(0,Q.jsx)(u.$,{children:c.ag.get("playlist.page-title",i)}),(0,Q.jsx)(x.s,{metadata:{...e.metadata,hasSpotifyTracks:!0},totalItems:Y,isPlaying:O,togglePlay:W,backgroundColor:P,specLikedSongs:R}),(0,Q.jsx)(K,{metadata:e.metadata,onClickTogglePlay:W,isPlaying:O,spec:A,logger:L,backgroundColor:P,canSort:a,canFilter:t}),(0,Q.jsx)("div",{className:"contentSpacing",children:F>0?(0,Q.jsx)(l.Suspense,{fallback:(0,Q.jsx)(g.h,{hasError:!1,errorMessage:c.ag.get("error.request-collection-tracks-failure")}),children:(0,Q.jsx)(I.Nh,{spec:M,children:(0,Q.jsx)(H.p,{nrTracks:F,collectionUri:n,scrollToUri:U,usePlayContextItem:z,outerDomRef:S,spec:M,initialItems:e.contents.items,isCompactMode:$})})}):(0,Q.jsx)(d.u,{message:c.ag.get("collection.empty-page.songs-subtitle"),title:c.ag.get("collection.empty-page.songs-title"),linkTo:"/search",linkTitle:c.ag.get("collection.empty-page.songs-cta"),renderInline:!0,children:(0,Q.jsx)(r.F,{"aria-hidden":"true"})})})]})})},ne=l.memo((function({user:e,uri:t}){const{filter:a}=(0,l.useContext)(p.fo),{sortState:n}=(0,l.useContext)(h.Gb),o=function(e,t,a){const n=(0,l.useContext)(F.H),o=(0,Y.useQueryClient)(),r=(0,$.jP)((()=>["useLikedSongs",e,a]),[e,a]),{data:s}=(0,Y.useQuery)(r(),(()=>n.getTracks(a)),{cacheTime:18e5,keepPreviousData:!0,refetchOnWindowFocus:!1}),i=(0,l.useCallback)((()=>{o.invalidateQueries(r())}),[o,r]);(0,X.b)(q.EW.UPDATE,i);const c=(0,te.I2)(t.id);return c&&s?{metadata:{uri:e,name:c.name,images:c.images,totalLength:s?.totalLength,unfilteredTotalLength:s.unfilteredTotalLength,owner:(0,ee.V)(t)},contents:s}:null}(t,e,{offset:0,limit:25,sort:(0,V.w)(n),filter:a}),r=(0,l.useContext)(F.H).getCapabilities();return o?(0,Q.jsx)(le,{data:o,canFilter:r.canFilterTracksAndEpisodes&&o.metadata.unfilteredTotalLength>0,canSort:r.canSortTracksAndEpisodes&&o.metadata.unfilteredTotalLength>0}):(0,Q.jsx)(g.h,{hasError:!1,errorMessage:c.ag.get("error.not_found.title.playlist"),loadOffline:r.canModifyOffline})})),oe=()=>{const{user:e}=(0,n.v9)(W.Gg);if(null===e)return null;const t=(0,i.wG)(e.id).toURI();return(0,Q.jsx)(h.kz,{uri:t,children:(0,Q.jsx)(p.hz,{uri:t,children:(0,Q.jsx)(Z.Y4,{children:(0,Q.jsx)(ne,{uri:t,user:e})})})})}}}]);
//# sourceMappingURL=xpui-routes-collection-songs.js.map